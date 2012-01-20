#include <iostream>

using namespace std;

long long fixmul(long long a, long long b) {
  unsigned long long u_a = (a < 0) ? -a : a,
                u_b = (b < 0) ? -b : b;
  unsigned long long result = (u_a * u_b) >> 18;
  cout << "Long size: " << sizeof(long long) << endl;
  cout << "Operands: " << u_a << ", " << u_b << endl;
  cout << "Intermediate result: " << (u_a * u_b) << endl;
  return (a < 0) ^ (b < 0) ? -result : result;
}

int main(int argc, const char* argv[]) {
  cout << "============================ Test Fixture Generator ===========================" << endl;

  long long result = fixmul(1 << 17, 1 << 17);
  cout << ".5 * .5 = " << result / (float)(1 << 18) << " (integer " << result
       << ")" << endl;
}
