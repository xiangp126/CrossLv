import gdb

class PrintMemoryCommand4(gdb.Command):
    """Print memory at the specified address using the x/4bu format."""
    def __init__(self):
        super(PrintMemoryCommand4, self).__init__("print4", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        # Check if an address is provided
        if not arg:
            print("Usage: print4 <memory_address>")
            return

        try:
            # Parse the provided address
            # address = gdb.parse_and_eval(arg)
            address = arg

            # Print the memory using x/4bu format
            print(gdb.execute(f"x/4bu {address}", to_string=True))

        except gdb.error as e:
            print(f"Error: {e}")

# Instantiate the command
PrintMemoryCommand4()
