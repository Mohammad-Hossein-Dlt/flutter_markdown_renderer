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

```python
# تعریف یک کلاس برای مدیریت کارها
class TodoList:
    name = ''
    def __init__(self):
        self.tasks = []

    # تابع برای اضافه کردن یک کار جدید
    def add_task(self, task):
        self.tasks.append(task)
        print(f'Task "{task}" added to the list.')

    # تابع برای نمایش تمام کارها
    def show_tasks(self):
        if not self.tasks:
            print('No tasks in the list.')
        else:
            print('Tasks:')
            for index, task in enumerate(self.tasks, start=1):
                print(f'{index}. {task}')

    # تابع برای حذف یک کار
    def remove_task(self, task_number):
        if 1 <= task_number <= len(self.tasks):
            removed_task = self.tasks.pop(task_number - 1)
            print(f'Task "{removed_task}" removed from the list.')
        else:
            print('Invalid task number.')

# تابع اصلی برای اجرای برنامه
def main():
    # ایجاد یک نمونه از کلاس TodoList
    todo_list = TodoList()

    while True:
        print('\n--- To-Do List Menu ---')
        print('1. Add Task')
        print('2. Show Tasks')
        print('3. Remove Task')
        print('4. Exit')

        # دریافت ورودی از کاربر
        choice = input('Enter your choice: ')

        if choice == 1:
            task = input('Enter the task: ')
            todo_list.add_task(task)
        elif choice == 2:
            todo_list.show_tasks()
        elif choice == 3:
            task_number = int(input('Enter the task number to remove: '))
            todo_list.remove_task(task_number)
        elif choice == 4:
            print('Exiting the program. Goodbye!')
            break
        else:
            print('Invalid choice. Please try again.')

# اجرای تابع اصلی
if __name__ == '__main__':
    main()
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
   6. فیلم دیدن به زبان اصلی می‌تونه helpful باشه.

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
1. سطح **اول** - آیتم ۱
   1. سطح **دوم** - آیتم ۱
      1. سطح سوم - آیتم ۱
         1. سطح **چهارم** - آیتم ۱
         2. سطح چهارم - آیتم ۲
      2. سطح سوم - آیتم ۲
   2. سطح دوم - آیتم ۲
2. سطح اول - آیتم ۲
   1. سطح دوم - آیتم ۱
      1. سطح سوم - آیتم ۱
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

>  elknmcvle lemv lemvlksdfnmv lksdfvnlskd fvlksdfnv lksdfvmlksdfjndlsfkv odiksljvkl;sdf vklsdjfjbvwekfnklsdfjvsdkfjlksedfjvhb.
>
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
پایتون از حلقه‌های `for` و `while` پشتیبانی می‌کند:
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
