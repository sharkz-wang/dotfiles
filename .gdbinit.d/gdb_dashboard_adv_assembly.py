# Based on commit 8a33017 of https://github.com/cyrus-and/gdb-dashboard

import ast
import fcntl
import os
import re
import struct
import termios

class AdvAssembly(Dashboard.Module):

    """Show the disassembled code surrounding the program counter. The
instructions constituting the current statement are marked, if available."""

    histq = []

    def label(self):
        return 'AdvAssembly'

    def lines(self, term_width, style_changed):
        line_info = None
        frame = gdb.selected_frame()  # PC is here
        disassemble = frame.architecture().disassemble
        try:
            # try to fetch the function boundaries using the disassemble command
            output = run('disassemble').split('\n')
            start = int(re.split('[ :]', output[1][3:], 1)[0], 16)
            end = int(re.split('[ :]', output[-3][3:], 1)[0], 16)
            asm = disassemble(start, end_pc=end)
            # find the location of the PC
            pc_index = next(index for index, instr in enumerate(asm)
                            if instr['addr'] == frame.pc())
            start = max(pc_index - self.context, 0)
            end = pc_index + self.context + 1
            asm = asm[start:end]
            # if there are line information then use it, it may be that
            # line_info is not None but line_info.last is None
            line_info = gdb.find_pc_line(frame.pc())
            line_info = line_info if line_info.last else None
        except (gdb.error, StopIteration):
            # if it is not possible (stripped binary or the PC is not present in
            # the output of `disassemble` as per issue #31) start from PC and
            # end after twice the context
            if len(self.histq) == 0 or frame.pc() < self.histq[0] or frame.pc() - self.histq[0] > 0x10:
                self.histq = []
                asm = disassemble(frame.pc(), count=2 * self.context + 1)
            else:
                asm = disassemble(self.histq[0], count=2 * self.context + 1)

            if not (len(self.histq) != 0 and self.histq[-1] == frame.pc()):
                self.histq.append(frame.pc())

            if len(self.histq) > 5:
                self.histq.pop(0)
        # fetch function start if available
        func_start = None
        if self.show_function and frame.name():
            try:
                value = gdb.parse_and_eval(frame.name()).address
                func_start = to_unsigned(value)
            except gdb.error:
                pass  # e.g., @plt
        # fetch the assembly flavor and the extension used by Pygments
        try:
            flavor = gdb.parameter('disassembly-flavor')
        except:
            flavor = None  # not always defined (see #36)
        filename = {
            'att': '.s',
            'intel': '.asm'
        }.get(flavor, '.s')
        # prepare the highlighter
        highlighter = Highlighter(filename)
        # return the machine code
        max_length = max(instr['length'] for instr in asm)
        inferior = gdb.selected_inferior()
        out = []
        for index, instr in enumerate(asm):
            addr = instr['addr']
            length = instr['length']
            text = instr['asm']
            addr_str = format_address(addr)
            if self.show_opcodes:
                # fetch and format opcode
                region = inferior.read_memory(addr, length)
                opcodes = (' '.join('{:02x}'.format(ord(byte))
                                    for byte in region))
                opcodes += (max_length - len(region)) * 3 * ' ' + ' '
            else:
                opcodes = ''
            # compute the offset if available
            if self.show_function:
                if func_start:
                    max_offset = len(str(asm[-1]['addr'] - func_start))
                    offset = str(addr - func_start).ljust(max_offset)
                    func_info = '{}+{} '.format(frame.name(), offset)
                else:
                    func_info = '? '
            else:
                func_info = ''
            format_string = '{}{}{}{}{}{}'
            indicator = ' '
            text = highlighter.process(text)

            is_bp = self.is_break_point(int(addr_str, 16))
            if not R.ansi:
                bp_mark = "BP " if is_bp else "   "
            else:
                bp_mark = ansi("BP ", R.style_error) if is_bp else "   "

            if addr == frame.pc():
                if not R.ansi:
                    indicator = '>'
                addr_str = ansi(addr_str, R.style_selected_1)
                opcodes = ansi(opcodes, R.style_selected_1)
                func_info = ansi(func_info, R.style_selected_1)
                if not highlighter.active:
                    text = ansi(text, R.style_selected_1)
            elif line_info and line_info.pc <= addr < line_info.last:
                if not R.ansi:
                    indicator = ':'
                addr_str = ansi(addr_str, R.style_selected_2)
                opcodes = ansi(opcodes, R.style_selected_2)
                func_info = ansi(func_info, R.style_selected_2)
                if not highlighter.active:
                    text = ansi(text, R.style_selected_2)
            else:
                addr_str = ansi(addr_str, R.style_low)
                func_info = ansi(func_info, R.style_low)
            out.append(format_string.format(bp_mark, addr_str, indicator,
                                            opcodes, func_info, text))
        return out

    def is_break_point(self, addr):
        for bp in map(lambda bp: int(bp.location.replace("*", ""), 16), gdb.breakpoints()):
            if addr == bp:
                return True
        return False

    def attributes(self):
        return {
            'context': {
                'doc': 'Number of context instructions.',
                'default': 3,
                'type': int,
                'check': check_ge_zero
            },
            'opcodes': {
                'doc': 'Opcodes visibility flag.',
                'default': False,
                'name': 'show_opcodes',
                'type': bool
            },
            'function': {
                'doc': 'Function information visibility flag.',
                'default': True,
                'name': 'show_function',
                'type': bool
            }
        }
