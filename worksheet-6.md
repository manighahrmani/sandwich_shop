    Note the use of `ScaffoldMessenger` which is a way of showing a message to the user that carries on even if the user navigates to a different screen. We can try this out by navigating to the cart screen after adding a sandwich to the cart. For more information, see the [Flutter documentation of `ScaffoldMessenger`](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html).


    Operations like this are **asynchronous** because they might take some time to complete. In Dart, an asynchronous operations like reading from or writing to a file returns a `Future` object, which is like a promise for an object that will be available later. 

    Here's a simple example, paste it in a file called `async-test.dart` on the root of your project (not inside `lib` or `test` folders) and run it with `dart run async-test.dart` to see how it works:

    ```dart
    Future<int> calculateTheAnswer() async {
      // Simulate a delay to mimic the delay in reading or writing a file
      await Future.delayed(const Duration(seconds: 2));
      return 42;
    }

    void main() async {
      print('Calculating...');
      int result = await calculateTheAnswer();
      print('The result is $result');
    }
    ```