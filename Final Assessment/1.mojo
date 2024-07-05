from time import now

@always_inline
fn is_leap_year(year: Int) -> Bool:
    return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

@always_inline
fn days_in_month(year: Int, month: Int) -> Int:
    if month == 2:
        return 29 if is_leap_year(year) else 28
    elif month == 4 or month == 6 or month == 9 or month == 11:
        return 30
    else:
        return 31

@always_inline
fn day_of_week(year: Int, month: Int, day: Int) -> Int:
    var y = year
    var m = month
    if m < 3:
        m += 12
        y -= 1
    var k = y % 100
    var j = y // 100
    return (day + 13*(m+1)//5 + k + k//4 + j//4 + 5*j) % 7

fn month_name(month: Int) -> String:
    if month == 1: return "January"
    elif month == 2: return "February"
    elif month == 3: return "March"
    elif month == 4: return "April"
    elif month == 5: return "May"
    elif month == 6: return "June"
    elif month == 7: return "July"
    elif month == 8: return "August"
    elif month == 9: return "September"
    elif month == 10: return "October"
    elif month == 11: return "November"
    else: return "December"

fn generate_month_calendar(year: Int, month: Int) -> String:
    var result = month_name(month) + " " + String(year) + "\n"
    result += "Sun Mon Tue Wed Thu Fri Sat\n"

    var first_day = day_of_week(year, month, 1)
    var num_days = days_in_month(year, month)

    var current_day = 1
    for _ in range(6):
        for weekday in range(7):
            if (current_day == 1 and weekday < first_day) or current_day > num_days:
                result += "    "
            else:
                if current_day < 10:
                    result += "  " + String(current_day) + " "
                else:
                    result += " " + String(current_day) + " "
                current_day += 1
        result += "\n"
    
    return result

fn generate_year_calendar(year: Int) -> String:
    var result = String()
    for month in range(1, 11):  # Only generate first 10 months
        result += generate_month_calendar(year, month) + "\n"
    return result

fn generate_calendar_range(start_year: Int, end_year: Int) -> String:
    var result = String()
    for year in range(start_year, end_year + 1):
        result += generate_year_calendar(year)
    return result

fn main():
    var start_year = 2010
    var end_year = 2030 

    print("Generating calendar...")
    var start_time = now()
    var calendar = generate_calendar_range(start_year, end_year)
    var end_time = now()
    
    print(calendar)
