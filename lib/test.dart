// 抽象类可以只声明方法，也可以有具体的方法实现，
// 但是不能直接用抽象类来创建实例，只能被继承使用或者充当接口
abstract class Animal {
  void eat() {}
  void sleep() {
    print(123);
  }

  // factory Animal() {
  //   return Cat();
  // }
}

// 这里用的是接口的方式，可以用继承的方式吗？
// 很遗憾不行，因为在抽象类中定义了工厂构造方法后，在子类中不能定义除工厂构造方法外的其它构造方法了，会报错
class Cat implements Animal {
  num a = 22;

  @override
  void eat() {
    print('吃');
    print(a);
  }

  @override
  void sleep() {}
}

class CofCat extends Cat {
  num a = 343;
}

void main() {
  // var an = CofCat();
  // an.eat();
  // an.sleep();
}
