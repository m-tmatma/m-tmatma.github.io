#!/usr/bin/python
#
# https://stackoverflow.com/questions/1825715/how-to-pack-and-unpack-using-ctypes-structure-str?rq=1
#
# this works on Python 3
import ctypes

class Test(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("testc", ctypes.c_byte),
        ("testa", ctypes.c_int),
        ("testb", ctypes.c_int),
        ]

class TestBig(ctypes.BigEndianStructure):
    _pack_ = 1
    _fields_ = [
        ("testc", ctypes.c_byte),
        ("testa", ctypes.c_int),
        ("testb", ctypes.c_int),
        ]

class TestBigArray(ctypes.BigEndianStructure):
    _pack_ = 1
    _fields_ = [
        ("testc", ctypes.c_byte),
        ("testa", ctypes.c_int),
        ("testb", ctypes.c_int),
        ("testd", ctypes.c_byte * 4),
        ]

def Test1():
    test1 = Test(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("c = ", test1.testc)
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)

    data = bytes(test1)
    print(data)

    test2 = Test.from_buffer_copy(data)
    print ("c = ", test2.testc)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)

def Test2():
    test1 = TestBig(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("c = ", test1.testc)
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)

    data = bytes(test1)
    print(data)

    test2 = TestBig.from_buffer_copy(data)
    print ("c = ", test2.testc)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)

def Test3():
    test1 = TestBig(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("c = ", test1.testc)
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)

    size = ctypes.sizeof(test1)
    buf = (ctypes.c_char * size)()
    ctypes.memmove(buf, ctypes.byref(test1), size)
    data = bytes(buf)
    print(data)

    test2 = TestBig.from_buffer_copy(data)
    print ("c = ", test2.testc)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)

def Test4():
    test1 = TestBigArray(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("c = ", test1.testc)
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)

    test1.testd[0] = 10
    test1.testd[1] = 11
    test1.testd[2] = 12
    test1.testd[3] = 13
    data = bytes(test1)
    print(data)

    test2 = TestBigArray.from_buffer_copy(data)
    print ("c = ", test2.testc)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)
    for i, d in enumerate(test2.testd):
        print (i, "d = ", d)
    data = bytes(test2)
    print(data)

Test1()
Test2()
Test3()
Test4()
