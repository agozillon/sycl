struct A {
  int i;
  long l;
  float f;
  double d;
};

enum E { e1, e2, e3 };
enum class EC { e1, e2, e3 };

extern constexpr A a{42, 47l, 4.2f, 4.7};
extern constexpr E e(e2);
extern constexpr EC ec(EC::e2);
