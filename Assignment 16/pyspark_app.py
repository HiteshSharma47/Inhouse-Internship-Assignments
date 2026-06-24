from pyspark.sql import SparkSession

# Create Spark Session
spark = SparkSession.builder \
    .appName("EmployeeRDDProcessing") \
    .getOrCreate()

sc = spark.sparkContext


# Function to convert CSV row into tuple
def parse_employee(row):
    data = row.split(",")

    return (
        int(data[0]),
        data[1],
        data[2],
        int(data[3])
    )


# Function to extract department and salary
def get_department_salary(emp):
    return (emp[2], emp[3])


# Function to add salaries
def add_salary(a, b):
    return a + b


# Function to get salary for sorting
def get_salary(emp):
    return emp[3]


# Read CSV
rdd = sc.textFile("employee.csv")

header = rdd.first()

def remove_header(row):
    return row != header

employees = (
    rdd.filter(remove_header)
       .map(parse_employee)
)

# ---------------------------------------
# Question 1
# ---------------------------------------

print("\n===== Employees Sorted By Salary =====\n")

sorted_employees = employees.sortBy(
    get_salary,
    ascending=False
)

sorted_result = sorted_employees.collect()

for emp in sorted_result:
    print(emp)

# ---------------------------------------
# Question 2
# ---------------------------------------

print("\n===== Department Wise Salary =====\n")

department_totals = (
    employees
    .map(get_department_salary)
    .reduceByKey(add_salary)
)

department_result = department_totals.collect()

for dept, total in department_result:
    print(dept, total)

# ---------------------------------------
# Question 3
# ---------------------------------------

print("\n===== Top 3 Highest Paid Employees =====\n")

top3 = sorted_employees.take(3)

for emp in top3:
    print(emp)

# ---------------------------------------
# Save all outputs
# ---------------------------------------

output = []

output.append("Employees Sorted By Salary")

for emp in sorted_result:
    output.append(str(emp))

output.append("")

output.append("Department Wise Salary")

for dept, total in department_result:
    output.append(f"{dept}: {total}")

output.append("")

output.append("Top 3 Highest Paid Employees")

for emp in top3:
    output.append(str(emp))

with open("output.txt", "w") as f:
    for line in output:
        f.write(line + "\n")

spark.stop()