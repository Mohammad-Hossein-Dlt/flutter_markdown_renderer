String d = '''
```python
print("wefcwercwercvfewr");
```
''';

String data = '''

- Text **bold** ![Image](https://picsum.photos/200)
  > Blockquote
  ```dart
  print("Code block");
  ```
  
     ```dart
     print("Code block");
     ```

  | Step | Description |
  |------|-------------|
  | 1    | Planning    |
  | 2    | Execution   |

1. *کلاس `~*TodoList*~`  *~`TodoList`~*:*
   - این کلاس یک **لیست** کارها را مدیریت می‌کند.
      - این کلاس یک **لیست** کارها را مدیریت می‌کند.
   - دارای متغیر `tasks` برای ذخیره کارها است.
   - توابع `add_task`، `show_tasks` و `remove_task` برای اضافه کردن، نمایش و حذف کارها استفاده می‌شوند.

2. *تابع main :*
   - این تابع اصلی برنامه است که منو را نمایش می‌دهد و بر اساس **انتخاب کاربر**، عملیات مناسب را انجام می‌دهد.
   - از توابع داخلی مانند `input` و `print` برای تعامل با کاربر استفاده می‌کند.

3. **توابع داخلی:**
   - `input`: برای **دریافت** ورودی از کاربر.
   - `print`: برای نمایش خروجی به کاربر.
   - `enumerate`: برای نمایش شماره‌ی هر کار در لیست.

4. **متغیرها:**
   - `todo_list`: یک نمونه از کلاس `TodoList` است.
   - `choice`: انتخاب کاربر از منو.
   - `task`: کار جدیدی که کاربر وارد می‌کند.
   - `task_number`: شماره‌ی کاری که کاربر می‌خواهد حذف کند.
   1. Learning a new skill takes time and effort.
      2. برای یادگیری زبان جدید، practice خیلی مهمه.
   3. Stay consistent and never give up.
   4. اگر می‌خواهید موفق شوید، باید focus کنید.
   5. Reading books is a great way to expand your knowledge.
   6. فیلم دیدن به زبان اصلی می‌تونه helpful باشه.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.

این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.

''';

String data2 = r'''

hello

در زیر یک نمونه کد پایتون آورده شده است که از توابع، متغیرها، کلاس‌ها و توابع داخلی **استفاده** می‌کند. این کد یک ~~برنامه~~ ساده برای مدیریت لیست کارها (To-Do List) است.

```java
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.List;
import java.util.Arrays;
import java.util.stream.Collectors;

public class AdvancedJavaExample {

    // متدی برای شبیه‌سازی دریافت داده از یک منبع با تأخیر
    public static CompletableFuture<String> fetchData(String source, int delay) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                System.out.println("در حال دریافت داده از " + source);
                // شبیه‌سازی تاخیر در دریافت داده
                TimeUnit.SECONDS.sleep(delay);
            } catch (InterruptedException e) {
                throw new IllegalStateException(e);
            }
            return "داده‌های " + source;
        });
    }

    public static void main(String[] args) {
        // ایجاد یک ThreadPool با 4 هسته برای اجرای موازی
        ExecutorService executor = Executors.newFixedThreadPool(4);

        // لیست منابع داده به عنوان نمونه
        List<String> sources = Arrays.asList("سرور1", "سرور2", "سرور3");

        // فراخوانی متد fetchData به صورت موازی برای هر منبع
        List<CompletableFuture<String>> futures = sources.stream()
                .map(source -> fetchData(source, 2))
                .collect(Collectors.toList());

        // ترکیب همه CompletableFutureها به وسیله allOf
        CompletableFuture<Void> allFutures = CompletableFuture.allOf(
                futures.toArray(new CompletableFuture[0])
        );

        // پس از تکمیل همه عملیات، جمع‌آوری نتایج
        CompletableFuture<List<String>> allResults = allFutures.thenApply(v ->
                futures.stream()
                        .map(CompletableFuture::join)
                        .collect(Collectors.toList())
        );

        // دریافت و چاپ نتایج
        try {
            List<String> results = allResults.get();
            results.forEach(System.out::println);
        } catch (InterruptedException | ExecutionException e) {
            System.err.println("خطا در اجرای عملیات: " + e.getMessage());
        } finally {
            executor.shutdown();
        }
    }
}

```

### جدول به زبان انگلیسی (Sales Data Example):

| Product ID | Product Name   | Category     | Units Sold | Revenue (USD) |
|------------|----------------|--------------|------------|---------------|
| 101        | **`Laptop X1`**      | Electronics  | 150        | 225,000       |
| 102        | Smartphone Y2  | Electronics  | 300        | 180,000       |
| 103        | Desk Chair Z3  | Furniture    | 80         | 40,000        |
| 104        | Coffee Maker A | `Home Appliances` | 120     | 60,000        |
| 105        | Bluetooth Speaker B | Electronics | 200    | 50,000        |


| نام       | سن  | شغل         | شهر      | حقوق (میلیون تومان) |
|-----------|-----|-------------|----------|----------------------|
| علی رضایی | 28  | برنامه‌نویس | تهران    | 12                   |
| مریم حسینی| 34  | دکتر        | اصفهان   | 25                   |
| رضا محمدی | 42  | مهندس عمران | مشهد     | 18                   |
| سارا کریمی| 29  | معلم        | شیراز    | 10                   |
| امیر عباسی| 31  | طراح گرافیک | تبریز    | 15                   |
| نازنین جوادی| 26  | حسابدار    | کرج      | 11                   |
| محسن قلی‌زاده | 39  | مدیر فروش  | اهواز    | 20                   |
| لیلا مرادی| 27  | پرستار      | قم       | 9                    |
| حسین نوروزی| 45  | استاد دانشگاه | کرمان   | 22                   |
| فاطمه امینی| 30  | وکیل        | رشت      | 17                   |

اگر نیاز به اطلاعات بیشتر یا تغییراتی در جدول دارید، خوشحال میشوم کمک کنم! 😊

### توضیحات کد:
## توضیحات کد:
# توضیحات کد:
# Code:

- Text **bold** ![Image](https://picsum.photos/200)
  > Blockquote
  ```dart
  print("Code1 1block1");
  ```
  
     ```dart
     print("Code1 1block");
     ```

  | Step | Description |
  |------|-------------|
  | 1    | Planning    |
  | 2    | Execution   |

   این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.

1. *کلاس `~*TodoList*~`  *~`TodoList`~*:*
   - این کلاس یک **لیست** کارها را مدیریت می‌کند.
      - این کلاس یک **لیست** کارها را مدیریت می‌کند.
   - دارای متغیر `tasks` برای ذخیره کارها است.
   - توابع `add_task`، `show_tasks` و `remove_task` برای اضافه کردن، نمایش و حذف کارها استفاده می‌شوند.

2. *تابع main :*
   - این تابع اصلی برنامه است که منو را نمایش می‌دهد و بر اساس **انتخاب کاربر**، عملیات مناسب را انجام می‌دهد.
   - از توابع داخلی مانند `input` و `print` برای تعامل با کاربر استفاده می‌کند.

3. **توابع داخلی:**
   - `input`: برای **دریافت** ورودی از کاربر.
   - `print`: برای نمایش خروجی به کاربر.
   - `enumerate`: برای نمایش شماره‌ی هر کار در لیست.

4. **متغیرها:**
   - `todo_list`: یک نمونه از کلاس `TodoList` است.
   - `choice`: انتخاب کاربر از منو.
   - `task`: کار جدیدی که کاربر وارد می‌کند.
   - `task_number`: شماره‌ی کاری که کاربر می‌خواهد حذف کند.
   1. Learning a new skill takes time and effort.
      2. برای یادگیری زبان جدید، practice خیلی مهمه.
   3. Stay consistent and never give up.
   4. اگر می‌خواهید موفق شوید، باید focus کنید.
   5. Reading books is a great way to expand your knowledge.
   6. فیلم دیدن به زبان اصلی می‌تونه helpful باشه.

این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.

''';

String data3 = '''

Here is the text as is:

---

1. *class `~*TodoList*~` *~`TodoList`~*:*
   - This class manages a **list** of tasks.
   - This class manages a **list** of tasks.
   | Step | Description |
   |------|------------|
   | 1 | Planning |
   | 2 | Execution |
   - It has a `tasks` variable to store tasks.
   - The `add_task`, `show_tasks` and `remove_task` functions are used to add, display and remove tasks.
   
2. *ت main :*
   - This is the main function of the program that displays the menu and performs the appropriate operation based on the **user's selection**.
   - It uses built-in functions like `input` and `print` to interact with the user.
   
3. **Built-in functions:**
   - `input`: To **receive** input from the user.
   - `print`: To display the output to the user.
   - `enumerate`: To display the number of each task in the list.
   
4. **Variables:**
   - `todo_list`: An instance of the `TodoList` class.
   - `choice`: The user's choice from the menu.
   - `task`: The new task that the user enters.
   - `task_number`: The task number that the user wants to delete.
   1. Learning a new skill takes time and effort.
   2. Practice is very important when learning a new language.
   3. Stay consistent and never give up.
   4. If you want to succeed, you have to focus.
   5. Reading books is a great way to expand your knowledge.
   6. Watching movies in the original language can be helpful.

---

این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.
این کد یک برنامه ساده ولی کاربردی است که مفاهیم پایه‌ای پایتون مانند توابع، کلاس‌ها، متغیرها و توابع داخلی را نشان می‌دهد.

''';

var dd = r'''

Certainly! Below is a Python code example that demonstrates the use of functions, variables, classes, and built-in functions:
🙏
```python
# Importing a built-in module
import math

# Defining a class
class Circle:
    def __init__(self, radius):
        # Instance variable
        self.radius = radius

    # Method to calculate the area of the circle
    def area(self):
        return math.pi * self.radius ** 2

    # Method to calculate the circumference of the circle
    def circumference(self):
        return 2 * math.pi * self.radius

# Defining a function that uses built-in functions
def print_circle_details(circle):
    print(f"Circle with radius {circle.radius}")
    print(f"Area: {circle.area():.2f}")
    print(f"Circumference: {circle.circumference():.2f}")

# Main function
def main():
    # Using built-in function to get user input
    radius = float(input("Enter the radius of the circle: "))

    # Creating an instance of the Circle class
    my_circle = Circle(radius)

    # Calling the function to print details
    print_circle_details(my_circle)

    # Using built-in function to find the maximum value
    circles = [Circle(r) for r in range(1, 6)]
    max_area_circle = max(circles, key=lambda c: c.area())
    print(f"\nCircle with the largest area has radius: {max_area_circle.radius}")

# Calling the main function
if __name__ == "__main__":
    main()
```


| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| `Row 1`  | Data 1   | Data 2   |
| Row 2    | Data 3   | Data 4   |

### Explanation:

1. **Class Definition (*`Circle`*)**:
   - The `Circle` class has an `__init__` method to initialize the radius.
   - It has two methods: `area()` and `circumference()` to calculate the area and circumference of the circle, respectively.

2. **Function (`print_circle_details`)**:
   - This function takes a `Circle` object as an argument and prints its details using the `print()` built-in function.

3. **Main Function (`main`)**:
   - The `main()` function is the entry point of the program.
   - It uses the `input()` built-in function to get the radius from the user.
   - It creates an instance of the `Circle` class and calls the `print_circle_details()` function to display the circle's details.
   - It also demonstrates the use of the `max()` built-in function to find the circle with the largest area from a list of circles.

4. **Built-in Functions**:
   - `input()`: To get user input.
   - `print()`: To display output.
   - `max()`: To find the maximum value in a list based on a key.
   - `float()`: To convert a string to a floating-point number.

5. **List Comprehension**:
   - A list of `Circle` objects is created using list comprehension.

### Running the Code:
When you run this code, it will prompt you to enter a radius, and then it will display the area and circumference of the circle. It will also create a list of circles with radii from 1 to 5 and print the radius of the circle with the largest area.

This example covers a variety of Python concepts, including classes, functions, variables, and built-in functions, providing a good overview of how they can be used together in a Python program.



''';

String ddd = '''
# Header 1

## Header 2

### Header 3

This is a simple توضیحات paragraph to demonstrate Markdown formatting.

- Unordered list item 1
   - Nested unordered item 1
   - این کلاس یک لیست کارها را مدیریت می‌کند.
      - Nested unordered item 2
         - Nested unordered item 2
            - Nested unordered item 2
               - Nested unordered item 2
   - Nested unordered item 3
- Unordered list item 2
   - Nested unordered item 4

1. Ordered list item 1
   2. Nested ordered item 1
      3. Nested ordered item 2
   4. Nested ordered item 3
5. Ordered list item 2
   6. Nested ordered item 4

> **This is a *blockquote* to showcase quoted text.**

```
This is a code block.
It can contain multiple lines of code.
```

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Row 1    | Data 1   | Data 2   |
| Row 2    | Data 3   | Data 4   |


''';

String d6 = '''

# Header 1: *مقدمه*

این یک **متن نمونه** است که شامل تمامی فرمت‌های Markdown می‌باشد.

## Header 2: ساختار اصلی

### Header 3: جزئیات

### Header 3: کد و جدول

---

در اینجا یک بلوک کد آورده شده است:

```python
# این یک مثال کد پایتون است
def greet(name):
    return f"Hello, {name}!"

print(greet("World"))

```

این یک پاراگراف معمولی است که در آن توضیحات اصلی ارائه می‌شود. در ادامه، لیستی از موارد مهم آورده شده است:

البته! در زیر یک مثال از یک لیست چهار سطحی در مارک‌داون آورده شده است:

### لیست مرتب (`ol`):
```markdown
1. سطح اول - آیتم ۱
   1. سطح دوم - آیتم ۱
      1. سطح سوم - آیتم ۱
         1. سطح چهارم - آیتم ۱
         2. سطح **چهارم** - آیتم ۲
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
2. سطح اول - آیتم ۲
   1. سطح دوم - آیتم ۱
      1. سطح سوم - آیتم ۱
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
```

### خروجی:
1. سطح *اول* - آیتم ۱
   1. سطح **دوم** - آیتم ۱
      1. سطح ***سوم*** - آیتم ۱
         1. سطح ~~چهارم~~ - آیتم ۱
         2. سطح چهارم - آیتم ۲
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
2. سطح *~~اول~~* - آیتم ۲
   1. سطح **~~دوم~~** - آیتم ۱
      1. سطح ***~~سوم~~*** - آیتم ۱
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲

---

### لیست نامرتب (`ul`):
```markdown
- سطح اول - آیتم ۱
  - سطح دوم - آیتم ۱
    - سطح سوم - آیتم ۱
      - سطح چهارم - آیتم ۱
      - سطح چهارم - آیتم ۲
    - سطح سوم - آیتم ۲
  - سطح دوم - آیتم ۲
- سطح اول - آیتم ۲
  - سطح دوم - آیتم ۱
    - سطح سوم - آیتم ۱
    - سطح سوم - آیتم ۲
  - سطح دوم - آیتم ۲
```

### خروجی:
- سطح اول - آیتم ۱
  - سطح دوم - آیتم ۱
    - سطح سوم - آیتم ۱
      - سطح **چهارم** - آیتم ۱
      - سطح چهارم - آیتم ۲
    - سطح سوم - آیتم ۲
  - سطح دوم - آیتم ۲
- سطح اول - آیتم ۲
  - سطح دوم - آیتم ۱
    - سطح سوم - آیتم ۱
    - سطح سوم - آیتم ۲
  - سطح دوم - آیتم ۲


در مارک‌داون، برای ایجاد سطوح تو در تو، باید از فاصله یا تب استفاده کنید (معمولاً ۲ یا ۴ فاصله). این روش برای ایجاد لیست‌های پیچیده و چند سطحی بسیار مفید است.

---

> این یک نقل‌قول **تو در تو** است.
> > > این یک نقل‌قول **تو در تو** است.

7. **تصویر**: با استفاده از ![alt text](url "https://picsum.photos/200/300") درج شده است.
8. **لینک**: با استفاده از [متن لینک](url) درج شده است.



''';

String d7 = '''

البته! در زیر یک مثال از یک بلاک نقل قول که شامل یک بلاک کد و یک بلاک نقل قول دیگر است آورده شده است:

> این یک بلاک نقل قول است که شامل یک بلاک کد و یک بلاک نقل قول دیگر می‌باشد.
>
> ```python
> def hello_world():
>     print("Hello, World!")
> ```
>
> > > این یک بلاک نقل قول تو در تو است. می‌توانید از این ساختار برای ***سازماندهی*** مطالب خود استفاده کنید.

امیدوارم این مثال به شما کمک کند! اگر سوال دیگری دارید، خوشحال می‌شوم کمک کنم.

''';

String d8 = '''

البته! در اینجا یک مثال از متن با پیچیده‌ترین سینتکس Markdown آورده شده است که شامل عناوین، لیست‌ها، کدهای درون خطی، بلاک‌های کد، نقل‌قول‌ها، جداول، لینک‌ها، تصاویر و حتی HTML سفارشی است:

---

# عنوان اصلی (سطح ۱)

## عنوان فرعی (سطح ۲)

### عنوان کوچک‌تر (سطح ۳)

این یک پاراگراف معمولی است که شامل **متن پررنگ**، *متن ایتالیک* و ~~متن خط‌خورده~~ می‌شود. همچنین می‌توانید از `کد درون خطی` استفاده کنید.

---

#### لیست‌ها

- این یک لیست نامرتب است:
  - آیتم ۱
  - آیتم ۲
    - زیرآیتم ۲.۱

1. این یک لیست مرتب است:
   1. آیتم اول
   2. آیتم دوم
      1. زیرآیتم ۲.۱

---

#### بلاک‌های کد

```python
def hello_world():
    print("Hello, World!")
```

```javascript
function greet() {
    console.log("Hello, World!");
}
```

---

#### نقل‌قول‌ها

> این یک بلاک نقل‌قول است.
>
> > این یک نقل‌قول تو در تو است.
>
> ```python
> print("This is a code block inside a blockquote!")
> ```

---

#### جداول

| ستون ۱       | ستون ۲       | ستون ۳       |
|--------------|--------------|--------------|
| مقدار ۱      | مقدار ۲      | مقدار ۳      |
| **پررنگ**    | *ایتالیک*    | ~~خط‌خورده~~ |
| `کد درون خطی`| [لینک](https://example.com) | ![تصویر](https://picsum.photos/200) |

---

#### لینک‌ها و تصاویر

- این یک [لینک به گوگل](https://google.com) است.
- این یک تصویر است:  
![لوگوی مارک‌داون](https://markdown-here.com/img/icon256.png)

---

#### HTML سفارشی

اگر نیاز به چیزی فراتر از Markdown دارید، می‌توانید از HTML استفاده کنید:

```html
<div style="background-color: #f0f0f0; padding: 10px; border-radius: 5px;">
  <p>این یک متن داخل یک <code>div</code> با استایل سفارشی است.</p>
  <button onclick="alert('Hello!')">کلیک کنید</button>
</div>
```

---

امیدوارم این مثال پیچیده به شما کمک کند! اگر سوال دیگری دارید، خوشحال می‌شوم کمک کنم. 😊

''';

String d9 = '''

در Markdown می‌توانید بسیاری از سینتکس‌ها را با هم ترکیب کنید تا متن‌های پیچیده‌تر و جذاب‌تری ایجاد کنید. در اینجا یک مثال از ترکیبی‌ترین و پیچیده‌ترین حالت‌ها با استفاده از سینتکس‌هایی که شما اشاره کردید (`~`, `~~`, `_`, `*`, `**`, `***`) آورده شده است:

---

### ترکیب سینتکس‌های مختلف

1. **متن پررنگ و ایتالیک با هم**:
   - `***این متن هم پررنگ است و هم ایتالیک***`  
    ***این متن هم پررنگ است و هم ایتالیک***

2. **متن خط‌خورده و پررنگ**:
   - `~~**این متن خط‌خورده و پررنگ است**~~`  
    ~~**این متن خط‌خورده و پررنگ است**~~

3. **متن ایتالیک و خط‌خورده**:
   - `~~_این متن خط‌خورده و ایتالیک است_~~`  
    ~~_این متن خط‌خورده و ایتالیک است_~~

4. **متن پررنگ و ایتالیک و خط‌خورده**:
   - `~~***این متن خط‌خورده، پررنگ و ایتالیک است***~~`  
    ~~***این متن خط‌خورده، پررنگ و ایتالیک است***~~

5. **متن با ترکیب کد درون خطی و پررنگ**:
   - `این یک متن با **`کد درون خطی`** و پررنگ است.`  
     این یک متن با **`کد درون خطی`** و پررنگ است.

6. **متن با ترکیب کد درون خطی و ایتالیک**:
   - `این یک متن با _`کد درون خطی`_ و ایتالیک است.`  
     این یک متن با _`کد درون خطی`_ و ایتالیک است.

7. **متن با ترکیب کد درون خطی، پررنگ و ایتالیک**:
   - `این یک متن با ***`کد درون خطی`*** و پررنگ و ایتالیک است.`  
     این یک متن با ***`کد درون خطی`*** و پررنگ و ایتالیک است.

8. **متن با ترکیب کد درون خطی، خط‌خورده و پررنگ**:
   - `این یک متن با ~~**`کد درون خطی`**~~ و خط‌خورده و پررنگ است.`  
     این یک متن با ~~**`کد درون خطی`**~~ و خط‌خورده و پررنگ است.

---

### مثال ترکیبی پیچیده

```markdown
این یک متن با ترکیب ***`کد درون خطی`*** و ~~_**پررنگ، ایتالیک و خط‌خورده**_~~ است. همچنین می‌توانید از [لینک‌ها](https://example.com) و ![تصاویر](https://via.placeholder.com/150) استفاده کنید.
```

**خروجی:**

این یک متن با ترکیب ***`کد درون خطی`*** و ~~_**پررنگ، ایتالیک و خط‌خورده**_~~ است. همچنین می‌توانید از [لینک‌ها](https://example.com) و ![تصاویر](https://via.placeholder.com/150) استفاده کنید.

---

این ترکیب‌ها به شما کمک می‌کنند تا متن‌های بسیار جذاب و پیچیده‌ای ایجاد کنید. اگر سوال دیگری دارید، خوشحال می‌شوم کمک کنم! 😊

''';

String d10 = '''

# **برنامه‌نویسی با پایتون: راهنمای جامع**

پایتون (Python) یکی از محبوب‌ترین زبان‌های برنامه‌نویسی در جهان است که به دلیل سادگی، خوانایی بالا و انعطاف‌پذیری، توجه بسیاری از برنامه‌نویسان، دانشجویان و حتی شرکت‌های بزرگ را به خود جلب کرده است. در این مقاله، به معرفی پایتون، کاربردهای آن و ارائه نمونه کدهایی برای درک بهتر این زبان خواهیم پرداخت.

---

## **rfefer چرا پایتون؟**

پایتون به دلایل زیر در میان زبان‌های برنامه‌نویسی برجسته است:

- **سادگی و خوانایی:** سینتکس پایتون شبیه به زبان طبیعی است و یادگیری آن آسان است.
- **چندمنظوره بودن:** از توسعه وب و تحلیل داده‌ها تا هوش مصنوعی و یادگیری ماشین، پایتون در همه جا کاربرد دارد.
- **کتابخانه‌های گسترده:** پایتون دارای هزاران کتابخانه آماده است که کار برنامه‌نویسی را سریع‌تر و آسان‌تر می‌کند.
- **جامعه بزرگ:** جامعه کاربران پایتون بسیار فعال است و منابع آموزشی بسیاری برای آن وجود دارد.

---

## **ویژگی‌های اصلی پایتون**

### 1. **زبان سطح بالا و مفسری**
پایتون یک زبان سطح بالا است، به این معنی که به زبان انسان نزدیک‌تر است و نیازی به مدیریت مستقیم حافظه یا سخت‌افزار ندارد. همچنین پایتون یک زبان مفسری است؛ یعنی کدها خط به خط اجرا می‌شوند.

### 2. **چند پلتفرمی**
پایتون روی سیستم‌عامل‌های مختلف مانند ویندوز، مک و لینوکس قابل اجراست.

### 3. **شیءگرایی و برنامه‌نویسی تابعی**
پایتون از هر دو سبک برنامه‌نویسی شیءگرا و تابعی پشتیبانی می‌کند.

---

## **نصب و شروع به کار با پایتون**

### **1. نصب پایتون**
برای نصب پایتون:
- به وب‌سایت رسمی پایتون [python.org](https://www.python.org/) بروید.
- نسخه مناسب سیستم‌عامل خود را دانلود و نصب کنید.

### **2. اجرای کد پایتون**
بعد از نصب، می‌توانید کدهای پایتون را به دو روش اجرا کنید:
- **استفاده از محیط تعاملی (REPL):**  
  کافی است در ترمینال یا CMD دستور `python` را وارد کنید.
- **اجرای فایل‌های پایتون:**  
  فایل‌های پایتون با پسوند `.py` ذخیره می‌شوند و با دستور زیر اجرا می‌شوند:  
  ```bash
  python filename.py
  ```

---

## **نمونه کدهای ساده در پایتون**

### **1. چاپ متن در پایتون**
برای چاپ یک پیام ساده در پایتون از تابع **print()** استفاده می‌شود:
```python
print("سلام دنیا!")
```

### **2. متغیرها و انواع داده‌ها**
پایتون به صورت خودکار نوع داده متغیرها را تشخیص می‌دهد:
```python
# تعریف متغیرها
name = "علی"
age = 25
is_student = True

# چاپ متغیرها
print("نام:", name)
print("سن:", age)
print("دانشجو است؟", is_student)
```

### **3. ساختارهای شرطی**
پایتون از ساختارهای شرطی برای تصمیم‌گیری استفاده می‌کند:
```python
age = 18

if age >= 18:
    print("شما بزرگسال هستید.")
else:
    print("شما کودک هستید.")
```

### **4. حلقه‌ها**
1پایتون از حلقه‌های `for` و `while` پشتیبانی می‌کند:
```python
# حلقه for
for i in range(5):
    print("عدد:", i)

# حلقه while
count = 0
while count < 5:
    print("شمارش:", count)
    count += 1
```

### **5. توابع**
توابع در پایتون با استفاده از کلمه کلیدی `def` تعریف می‌شوند:
```python
def greet(name):
    return f"سلام {name}!"

print(greet("علی"))
```

---

## **کاربردهای پایتون**

### **1. توسعه وب**
پایتون با فریم‌ورک‌هایی مانند **Django** و **Flask** برای توسعه وب استفاده می‌شود.  
مثال: ساخت یک سرور ساده با Flask:
```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "سلام دنیا!"

if __name__ == "__main__":
    app.run(debug=True)
```

### **2. تحلیل داده‌ها**
پایتون با کتابخانه‌هایی مانند **Pandas** و **NumPy** برای تحلیل داده‌ها استفاده می‌شود.  
مثال: کار با داده‌ها در Pandas:
```python
import pandas as pd

data = {"نام": ["علی", "رضا", "سارا"], "سن": [25, 30, 22]}
df = pd.DataFrame(data)

print(df)
```

### **3. یادگیری ماشین و هوش مصنوعی**
کتابخانه‌هایی مانند **TensorFlow** و **scikit-learn** برای یادگیری ماشین و هوش مصنوعی استفاده می‌شوند.  
مثال: مدل یادگیری ماشین ساده با scikit-learn:
```python
from sklearn.linear_model import LinearRegression

# داده‌های نمونه
X = [[1], [2], [3]]
y = [2, 4, 6]

# ایجاد مدل
model = LinearRegression()
model.fit(X, y)

# پیش‌بینی
print("پیش‌بینی برای 4:", model.predict([[4]]))
```

---

## **مدیریت خطاها در پایتون**

پایتون از بلوک‌های `try-except` برای مدیریت خطاها استفاده می‌کند:
```python
try:
    num = int(input("یک عدد وارد کنید: "))
    print("عدد شما:", num)
except ValueError:
    print("لطفاً یک عدد معتبر وارد کنید.")
```

---

## **نکات مهم در برنامه‌نویسی پایتون**

- **استفاده از نام‌گذاری معنادار:**  
  نام متغیرها و توابع باید گویا و معنادار باشند.
  
- **خوانایی کد:**  
  استفاده از فاصله‌گذاری و تورفتگی (Indentation) مناسب برای خوانایی کد ضروری است.

- **استفاده از کتابخانه‌ها:**  
  از کتابخانه‌های آماده برای کاهش زمان توسعه استفاده کنید.

---

## **نتیجه‌گیری**

پایتون زبانی قدرتمند و انعطاف‌پذیر است که برای برنامه‌نویسان در تمام سطوح مناسب است. چه تازه‌کار باشید و چه یک برنامه‌نویس حرفه‌ای، پایتون ابزارهای لازم برای ساخت برنامه‌های کاربردی، تحلیل داده‌ها و حتی توسعه هوش مصنوعی را در اختیار شما قرار می‌دهد. با یادگیری این زبان، می‌توانید در دنیای فناوری پیشرفت چشمگیری داشته باشید.

---

### **منابع پیشنهادی برای یادگیری بیشتر**
- [وب‌سایت رسمی پایتون](https://www.python.org/)
- [مستندات Django](https://www.djangoproject.com/)
- [دوره‌های آموزشی رایگان در Codecademy](https://www.codecademy.com/)

**با پایتون شروع کنید و دنیای برنامه‌نویسی را کشف کنید!** 🚀
''';

String d11 = r'''

### حل مسئله مکانیک سیالات

#### اطلاعات مسئله:
- تابع جریان (\( \psi \)) داده شده است:
  \[
  \psi = -5Ax - 2Ay
  \]

  که در آن \( A = 2 \, \text{m/s} \) است.
- \( x \) و \( y \) مختصات هستند (بر حسب متر).
- خواسته‌ها:
  1. رسم خطوط جریان \( \psi = 0 \) و \( \psi = 5 \) و تعیین جهت بردار سرعت در نقطه \( (0, 0) \).
  2. محاسبه دبی بین خطوط جریان عبوری از نقاط \( (2, 2) \) و \( (4, 1) \).

---

### گام (a): رسم خطوط جریان \( \psi = 0 \) و \( \psi = 5 \)

#### تعریف خطوط جریان:
خطوط جریان با معادله \( \psi = \text{ثابت} = \text{ثابت}  \) مشخص می‌شوند. بنابراین، برای این مسئله:
\[
\psi = -5Ax - 2Ay
\]
با جایگذاری \( A = 2 \):
\[
\psi = -10x - 4y
\]

برای خطوط جریان:
1. **خط \( \psi = 0 \):**
   \[
   -10x - 4y = 0 \quad \Rightarrow \quad y = -\frac{10}{4}x = -2.5x
   \]
   این خط از مبدأ (0, 0) عبور می‌کند و شیب آن \( -2.5 \) است.

2. **خط \( \psi = 5 \):**
   \[
   -10x - 4y = 5 \quad \Rightarrow \quad y = -2.5x - \frac{5}{4}
   \]
   این خط نیز شیب \( -2.5 \) دارد، اما از نقطه \( (0, -1.25) \) عبور می‌کند.

#### رسم خطوط جریان:
برای رسم، ابتدا نقاطی روی هر خط پیدا می‌کنیم:
- برای \( \psi = 0 \): \( (x, y) = (0, 0) \) و \( (1, -2.5) \).
- برای \( \psi = 5 \): \( (x, y) = (0, -1.25) \) و \( (1, -3.75) \).

این خطوط در یک صفحه \( x-y \) رسم می‌شوند.

#### جهت بردار سرعت در \( (0, 0) \):
بردار سرعت \( \vec{V} \) از تابع جریان به صورت زیر محاسبه می‌شود:
\[
u = \frac{\partial \psi}{\partial y}, \quad v = -\frac{\partial \psi}{\partial x}
\]
با مشتق‌گیری از \( \psi = -10x - 4y \):
\[
u = \frac{\partial \psi}{\partial y} = -4, \quad v = -\frac{\partial \psi}{\partial x} = 10
\]
بنابراین، بردار سرعت در \( (0, 0) \):
\[
\vec{V} = (u, v) = (-4, 10)
\]
جهت بردار سرعت به سمت بالا و چپ است.

---

### گام (b): محاسبه دبی بین دو خط جریان

#### تعریف دبی بین خطوط جریان:
دبی بین دو خط جریان برابر با اختلاف مقادیر تابع جریان در آن دو خط است:
\[
Q = \Delta \psi = \psi_2 - \psi_1
\]

1. محاسبه \( \psi \) در نقطه \( (2, 2) \):
   \[
   \psi = -10x - 4y = -10(2) - 4(2) = -20 - 8 = -28
   \]

2. محاسبه \( \psi \) در نقطه \( (4, 1) \):
   \[
   \psi = -10x - 4y = -10(4) - 4(1) = -40 - 4 = -44
   \]

3. اختلاف مقادیر تابع جریان:
   \[
   Q = \Delta \psi = \psi_2 - \psi_1 = -44 - (-28) = -44 + 28 = -16
   \]

#### مقدار دبی:
مقدار دبی برابر با \( |Q| = 16 \, \text{m}^2/\text{s} \) است. علامت منفی نشان‌دهنده جهت جریان است، اما مقدار مطلق دبی \( 16 \, \text{m}^2/\text{s} \) است.

---

### نتیجه نهایی:

1. خطوط جریان \( \psi = 0 \) و \( \psi = 5 \) رسم شدند. جهت بردار سرعت در \( (0, 0) \) به سمت بالا و چپ است.
2. دبی بین خطوط جریان عبوری از \( (2, 2) \) و \( (4, 1) \) برابر با \( 16 \, \text{m}^2/\text{s} \) است.

#### نمودار:
برای رسم نمودار، دو خط \( y = -2.5x \) و \( y = -2.5x - 1.25 \) را در یک صفحه مختصات رسم کنید و جهت بردار سرعت \( (-4, 10) \) را در نقطه \( (0, 0) \) با یک فلش نشان دهید.

''';

String d12 = r'''

To address this problem, we first need to analyze the given stream function, \(\Psi = -5Ax - 2Ay\), where \(A = 2\) m/s.

### Part (a): Sketching the Streamlines

1. **Streamlines Equation**:
   The streamlines are defined by the equation \(\Psi = \text{constant}\). For our case, we will consider two values: \(\Psi = 0\) and \(\Psi = 5\).

   - For \(\Psi = 0\):
   \[
   -5Ax - 2Ay = 0
   \]
   Substituting \(A = 2\):
   \[
   -10x - 4y = 0 \quad \Rightarrow \quad 10x + 4y = 0 \quad \Rightarrow \quad y = -\frac{5}{2}x
   \]

   This is a straight line through the origin with a slope of \(-\frac{5}{2}\).

   - For \(\Psi = 5\):
   \[
   -5Ax - 2Ay = 5 \quad \Rightarrow \quad -10x - 4y = 5 \quad \Rightarrow \quad 10x + 4y = -5 \quad \Rightarrow \quad y = -\frac{5}{4} - \frac{5}{2}x
   \]

   This equation describes a line with a slope of \(-\frac{5}{2}\) but shifted downwards because of the \(-\frac{5}{4}\) intercept.

2. **Plotting the Lines**:
   - For \(\Psi = 0\): Starts at the origin and has the equation \(y = -\frac{5}{2}x\).
   - For \(\Psi = 5\): This line has a slight shift downwards, starting at the point \((0, -\frac{5}{4})\).

3. **Direction of the Velocity Vector**:
   The velocity vector \(\mathbf{V}\) in terms of the stream function can be determined from:
   \[
   V_x = \frac{\partial \Psi}{\partial y} \quad \text{and} \quad V_y = -\frac{\partial \Psi}{\partial x}
   \]

   Calculating these for our stream function:
   \[
   \frac{\partial \Psi}{\partial y} = -2A = -4 \quad \text{and} \quad \frac{\partial \Psi}{\partial x} = -5A = -10
   \]
   Thus,
   \[
   V_x = -2A \quad \Rightarrow \quad V_x = -4 \quad \text{and} \quad V_y = 10
   \]
   So at the point \((0, 0)\), the velocity vector is:
   \[
   \mathbf{V} = (-4, 10)
   \]
   This indicates that the velocity flows in the positive \(y\)-direction (upwards) and negative \(x\)-direction (to the left).

### Summary of Part (a):
- **Streamlines**:
  - \(\Psi = 0\): Line with equation \(y = -\frac{5}{2}x\)
  - \(\Psi = 5\): Line with equation \(y = -\frac{5}{4} - \frac{5}{2}x\)
- **Velocity Vector at (0,0)**: Pointing negative \(x\) (left) and positive \(y\) (up).

''';

String d13 = r'''

بسیار عالی! در فرمت ریاضی، ماتریس‌ها معمولاً به صورت مجموعه‌ای از اعداد درون پرانتزهای بزرگ یا براکت‌های مربعی نمایش داده می‌شوند. به عنوان مثال، یک ماتریس \( 3 \times 3 \) (سه سطر و سه ستون) به صورت زیر است:

\[
\mathbf{A} =
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6 \\
7 & 8 & 9
\end{bmatrix}
\]

اگر بخواهید، می‌توانم یک ماتریس خاص با ویژگی‌های مشخص برایتان بنویسم. آیا ماتریس خاصی مد نظرتان است؟ مثلاً:

- ماتریس همانی (\( I \))؟
- ماتریس صفر (\( 0 \))؟
- ماتریس تصادفی؟
- یا ماتریسی با اعداد دلخواه؟

لطفاً بیشتر توضیح دهید تا دقیقاً همان چیزی که می‌خواهید را ارائه دهم. 😊

''';

String d14 = r'''

# عنوان سطح ۱
## عنوان سطح ۲
### عنوان سطح ۳
#### عنوان سطح ۴
##### عنوان سطح ۵
###### عنوان سطح ۶
___
این یه متن معمولی هست

**این یه متن بولد هست**  

*این یه متن ایتالیک هست*  

***این یه متن بولد و ایتالیک هست***  

~~این یه متن خط‌خورده هست~~ 

*~~این یه متن ایتالیک و خط‌خورده هست~~*  

**~~این یه متن بولد و خط‌خورده هست~~**  

***~~این یه متن بولد، ایتالیک و خط‌خورده هست~~***  
___
این یک `inline code` است.
___
```dart
void main() {
  String name = 'Ali'; // Define a string variable
  int age = 20; // Define an integer variable

  print('Hello, my name is $name and I am $age years old.'); // Print a message

  if (age > 18) { // Check if age is greater than 18
    print('I am an adult.');
  } else { // If age is 18 or less
    print('I am a child.');
  }
}
```
___
1. سطح *اول* - آیتم ۱
   1. سطح **دوم** - آیتم ۱
      1. سطح ***سوم*** - آیتم ۱
         1. سطح ~~چهارم~~ - آیتم ۱
         2. سطح چهارم - آیتم ۲
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
2. سطح *~~اول~~* - آیتم ۲
   1. سطح **~~دوم~~** - آیتم ۱
      1. سطح ***~~سوم~~*** - آیتم ۱
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
___
> این یک نقل‌قول **تو در تو** است.
> > > این یک نقل‌قول **تو در تو** است.
___
\[
u = \frac{\partial \psi}{\partial y} = -4, \quad v = -\frac{\partial \psi}{\partial x} = 10
\]
___
این یک **تصویر** است ![Image](https://picsum.photos/200)
___
[این یک لینک است](https://www.google.com/)

''';

String d15 = r'''

# Level 1 Title
## Level 2 Title
### Level 3 Title
#### Level 4 Title
##### Level 5 Title
###### Level 6 Title
___
This is a normal text.

**This is bold text.**  

*This is italic text.*  

***This is bold and italic text.***  

~~This is strikethrough text.~~ 

*~~This is italic and strikethrough text.~~*  

**~~This is bold and strikethrough text.~~**  

***~~This is bold, italic, and strikethrough text.~~***  
___
This is an `inline code`.
___
```dart
void main() {
  String name = 'Ali'; // Define a string variable
  int age = 20; // Define an integer variable

  print('Hello, my name is $name and I am $age years old.'); // Print a message

  if (age > 18) { // Check if age is greater than 18
    print('I am an adult.');
  } else { // If age is 18 or less
    print('I am a child.');
  }
}
```
___
1. Level *One* - Item 1
   1. Level **Two** - Item 1
      1. Level ***Three*** - Item 1
         1. Level ~~Four~~ - Item 1
         2. Level Four - Item 2
      2. Level Three - Item 2
   2. Level Two - Item 2
2. Level *~~One~~* - Item 2
   1. Level **~~Two~~** - Item 1
      1. Level ***~~Three~~*** - Item 1
      2. Level Three - Item 2
   2. Level Two - Item 2
___
> This is a **nested quote**.
> > > This is a **nested quote**.
___
\[
u = \frac{\partial \psi}{\partial y} = -4, \quad v = -\frac{\partial \psi}{\partial x} = 10
\]
___
This is an **image**! ![Image](https://picsum.photos/200)
___
[This is a link](https://www.google.com/)

''';
