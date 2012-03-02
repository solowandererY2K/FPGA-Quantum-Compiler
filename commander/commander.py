"""
Quantum Compiler command interface.
"""

import sys, os, serial
from math import sqrt
from pprint import pprint

# PORTS_TO_TRY contains the list of ports the BlimpBot interface will
# attempt to connect to.  Each number n corresponds to port COM(n+1),
# so 2 means COM3, 3 means COM4, etc.
PORTS_TO_TRY = (0,)
PORT_SPEED = 115200

NUM_BYTES     = 5
NUM_BITS      = 37
NUM_FRAC_BITS = 35

class QuantumCompilerInterface(object):
  def __init__(self):
    """Initializes the interface."""
    self.connect()

  def connect(self):
    ports = list(PORTS_TO_TRY)
    while True:
        try:
            if not ports:
                print "No ports available."
            port = ports.pop(0)
            self.ser = serial.Serial(port, PORT_SPEED)
            print "***** Successfully connected to COM%d *****" % (port + 1)
            print "=" * 80
            break
        except Exception as ex:
            print "Failed to connect to serial port COM%d\nDetails:\n%s" % (port + 1, ex)
            if ports:
                print "***** Let's try another port! *****"
            else:
                print "=" * 80
                print "No more ports left to try."
                # TODO: exit more nicely
                sys.exit(1)
            print "-" * 80

  def send_number(self, num):
    num = int(num * (2**NUM_FRAC_BITS))
    for i in xrange(NUM_BYTES):
      byte = num & 255
      #print "Sent %d" % byte
      self.ser.write(chr(byte))
      #sys.stdout.write("%s " % (num & 255))
      num >>= 8

  def send_complex_number(self, num):
    if type(num) == complex:
      self.send_number(num.real)
      self.send_number(num.imag)
    else:
      self.send_number(num)
      self.send_number(0)

  def send_matrix(self, mtx):
    for row in mtx:
      for cell in row:
        self.send_complex_number(cell)

  def send_command(self, cmd):
    #sys.stdout.write("%s " % ord(cmd))
    self.ser.write(cmd)

  def read_number(self):
    num_bytes = self.ser.read(NUM_BYTES)
    #print [ord(x) for x in num_bytes]
    shift = 0
    num = 0
    for byte in num_bytes:
      num |= (ord(byte) << shift)
      shift += 8

    # Sign-extend the number if it's negative.
    if num & (1 << (NUM_BITS - 1)):
      num |= -1 ^ ((1 << (NUM_BITS)) - 1)

    # Convert it to a float.
    return num / (2.**NUM_FRAC_BITS)

  def read_complex_number(self):
    return complex(self.read_number(), self.read_number())

  def read_matrix(self):
    return [[self.read_complex_number() for _ in xrange(2)]
            for _ in xrange(2)]

def test_matrix_benchmark():
  sqrt2o2 = sqrt(2) / 2;
  mtx_a = (
    (sqrt2o2, sqrt2o2),
    (sqrt2o2, -sqrt2o2),
  )
  mtx_b = (
    (1, 0),
    (0, complex(sqrt2o2, sqrt2o2))
  )
  print "Starting matrix benchmark..."
  qci = QuantumCompilerInterface()
  qci.send_command('B')
  print "\nSending matrix A:"
  pprint(mtx_a)
  qci.send_matrix(mtx_a)
  print "\nSending matrix B:"
  pprint(mtx_b)
  qci.send_matrix(mtx_b)
  print "\nResult:"
  pprint(qci.read_matrix())

if __name__ == '__main__':
  test_matrix_benchmark()
