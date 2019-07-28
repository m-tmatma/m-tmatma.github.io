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

def Test1():
    test1 = Test(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)
    print ("c = ", test1.testc)

    data = bytes(test1)
    print(data)

    test2 = Test.from_buffer_copy(data)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)
    print ("c = ", test2.testc)

def Test2():
    test1 = TestBig(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)
    print ("c = ", test1.testc)

    data = bytes(test1)
    print(data)

    test2 = TestBig.from_buffer_copy(data)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)
    print ("c = ", test2.testc)

def Test3():
    test1 = TestBig(1, 2, 3)
    print ("size = ", ctypes.sizeof(test1))
    print ("a = ", test1.testa)
    print ("b = ", test1.testb)
    print ("c = ", test1.testc)

    size = ctypes.sizeof(test1)
    buf = (ctypes.c_char * size)()
    ctypes.memmove(buf, ctypes.byref(test1), size)
    data = bytes(buf)
    print(data)

    test2 = TestBig.from_buffer_copy(data)
    print ("a = ", test2.testa)
    print ("b = ", test2.testb)
    print ("c = ", test2.testc)

Test1()
Test2()
Test3()
