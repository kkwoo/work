const fsPromises = require('node:fs/promises');
const fs = require('node:fs');
const { Buffer } = require('node:buffer');

const spyTarget = "c:/u/urandom.head100+.od.txt";
fs.watchFile(spyTarget,
            {interval: 1000},
            tailFile);

function tailFile(curr, prev) {
    fsPromises.open(spyTarget, "r")
      .then((fh) => {
        //// allocate buffer based on size change
        let fileGrowth = curr.size - prev.size;
        let readOffset = prev.size - 1;
        let buf = Buffer.alloc(fileGrowth);
        //// read (curr.size-prev.size) bytes from offset (prev.size)
        fh.read(buf, 0, fileGrowth, readOffset)
          .then((res) => {
            // console.log(`OUTPUT: ${res.buffer.toString()}`);
            process.stdout.write(res.buffer.toString());
            return(res);
          })
          .then((res) => {
              res = null;
          });
        //// output read buffer to screen
        return(fh);
      })
      .then((fh) => {fh.close();});
}
