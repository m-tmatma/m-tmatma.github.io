#!/usr/bin/python

import io

data = b'abcdef'
f = io.BytesIO(data)

for i in range(0, 10):
    data = f.read(1)
    print (type(data))
    print (len(data))
    print (data)
