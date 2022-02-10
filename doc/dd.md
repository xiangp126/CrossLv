### dd
dd -- convert and copy a file

     bs=n     Set both input and output block size to n bytes, superseding the ibs and obs operands.  If no conversion values
              other than noerror, notrunc or sync are specified, then each input block is copied to the output as a single block
              without any aggregation of short blocks.

#### copy a whole disk
```bash
dd if=/dev/sda of=/dev/sdb bs=32M
```