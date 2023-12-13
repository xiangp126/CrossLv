import re
import gdb

class PrintMemoryCommand4(gdb.Command):
    """Print memory at the specified address using the x/4bu format."""
    def __init__(self):
        super(PrintMemoryCommand4, self).__init__("pt4", gdb.COMMAND_USER)

    def print_ses_ctx_memories(self):
        # Define the addresses with the requested format
        addresses = [
            "&ses_ctx->src_addr.sa4.sin_addr",
            "&ses_ctx->dst_addr.sa4.sin_addr",
            "&ses_ctx->orig_src_addr.sa4.sin_addr",
            "&ses_ctx->orig_dst_addr.sa4.sin_addr",
        ]

        ports = [
            "&ses_ctx->src_addr.sa4.sin_port",
            "&ses_ctx->dst_addr.sa4.sin_port",
            "&ses_ctx->orig_src_addr.sa4.sin_port",
            "&ses_ctx->orig_dst_addr.sa4.sin_port",
        ]

        for (address, port) in zip(addresses, ports):
            try:
                # x/2bu &ses_ctx->src_addr.sa4.sin_port
                # 0x7f01609f1e3a: 209     30
                ret_port = gdb.execute(f"x/2bu {port}", to_string=True)
                # ['209', '30']
                numbers = re.findall(r'\b\d+\b', ret_port)
                int_values = [int(num) for num in numbers]
                port_value = int_values[0] * 256 + int_values[1]

                # ++x/4bu &ses_ctx->orig_dst_addr.sa4.sin_addr
                # 0x7f01609f1e90: 192     168     103     100
                ret_addr = gdb.execute(f'x/4bu {address}', to_string=True)
                print(f"{ret_addr.rstrip()}    (Big-endian port = {port_value})")

            except gdb.error as e:
                print(f"Error: {e}", end="")

    # Convert the integer to bytes in big-endian order
    def convert_le_to_be(self, value, length=4):
        # Convert the integer to bytes in big-endian order
        bytes_be = value.to_bytes(length, byteorder='little')
        hex_string = ' '.join(f'0x{format(byte, "02X")}' for byte in bytes_be)
        # Big-endian bytes: 0x00 0x15
        print(f"Big-endian bytes: {hex_string}")

        # Convert the Big-endian bytes to integers
        values = [int(byte) for byte in bytes_be]

        if length == 2:
            port_num = values[0] * 256 + values[1]
            print(f"Big-endian port: {port_num}")
        else:
            # Format the result as a string
            result = '.'.join(map(str, values))
            print(f"Big-endian IP address: {result}")

    # Print the memory using x/4bu format or x/2bu format
    def print_memory_bytes(self, num, arg):
        result = gdb.execute(f"x/{num}bu {arg}", to_string=True)
        print(result, end="")

    def invoke(self, arg, from_tty):
        # Check if an address is provided
        if not arg:
            print("Usage: print4 <memory_address>")
            return

        try:
            # Check if the address is ses_ctx
            if arg == "ses_ctx" or arg == "&ses_ctx":
                self.print_ses_ctx_memories()
            else:
                # Check if the address is a pointer or a value
                result = gdb.parse_and_eval(arg)
                type = result.type
                # default number of bytes needed to represent the type
                byte_length = 4
                # Type: struct wad_session_context *, Value: 0x7f01609f5c88
                print(f"Type: {type}, Value: {result}")
                # Type: __be16, Value: 5376
                if "16" in str(type):
                   byte_length = 2

                if "0x" in str(result):
                    address = arg
                else:
                    # Type: int, Value: 1684515008
                    self.convert_le_to_be(int(result), byte_length)
                    return

                self.print_memory_bytes(byte_length, address)

        except gdb.error as e:
            print(f"Error: {e}")

# Instantiate the command
PrintMemoryCommand4()
