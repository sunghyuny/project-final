const calendarDays = document.querySelectorAll(".calendar_days"),
    calendarTitle = document.querySelector(".title"),
    leftButton = document.querySelector(".left_button"),
    rightButton = document.querySelector(".right_button"),
    calendar = document.querySelector(".calendar");


class Calendar {
    constructor(year, month) {
        this.today = new Date(year, month);
        this.year = this.today.getFullYear(),
            this.month = this.today.getMonth(),
            this.date = this.today.getDate(),
            this.day = this.today.getDay()
    }


    getFirstDay() {
        const firstDate = new Date(this.year, this.month);
        return firstDate.getDay();
    }

    getLastDay() {
        let wholeDays = [];
        if ((this.year % 4 === 0 && this.year % 100 !== 0) || (this.year % 400 === 0)) {
            wholeDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        } else {
            wholeDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        }
        return wholeDays[this.month];
    }

    fillCalendar() {
        this.initCalendar();
        calendarTitle.innerHTML = `${this.year}년 ${this.month + 1}월`
        const firstDay = this.getFirstDay();
        const lastDay = this.getLastDay();
        let day = 1;
        for (let i = firstDay; i < calendarDays.length; i++) {
            if (day <= lastDay) {
                calendarDays[i].innerHTML = `<button class = "day_button">${day}</button>`;
                day++;
            }

        }
    }

    initCalendar() {
        calendarDays.forEach((e) => {
            e.innerHTML = "";
        });
    }


    drawCalendar() {
        let change = 0;
        const today = new Date();
        let calendarInstance = new Calendar(today.getFullYear(), today.getMonth() + change);

        calendarInstance.fillCalendar();

        leftButton.addEventListener("click", (e) => {
            e.stopPropagation();
            change--;
            calendarInstance = new Calendar(today.getFullYear(), today.getMonth() + change);
            calendarInstance.fillCalendar();
            this.updateCalendarStyle();
        });
        rightButton.addEventListener("click", (e) => {
            e.stopPropagation();
            change++;
            calendarInstance = new Calendar(today.getFullYear(), today.getMonth() + change);
            calendarInstance.fillCalendar();
            this.updateCalendarStyle();
        });
    }


    updateCalendarStyle() {
        const dayButtons = document.querySelectorAll(".day_button");
        let firstSelectedDay = 0;
        let lastSelectedDay = 0;
        let clickCount = 0;

        dayButtons.forEach((element) => {
            element.classList.remove("day_selected");
            calendarDays.forEach((e) => e.classList.remove("gray"));
        })


        dayButtons.forEach((element) => {
            element.addEventListener("click", (event) => {
                event.target.classList.toggle("day_selected");

                clickCount++;

                if (firstSelectedDay === 0) {
                    firstSelectedDay = Number(event.target.innerText);
                } else {
                    lastSelectedDay = Number(event.target.innerText);
                }

                if (clickCount > 2) {
                    dayButtons.forEach((e) => {
                        e.parentNode.classList.remove("gray");
                        e.parentNode.classList.remove("gray2");
                        e.parentNode.classList.remove("gray3");
                        e.classList.remove("day_selected");
                        clickCount = 0;
                        firstSelectedDay = 0;
                        lastSelectedDay = 0;
                    });
                }

                if (firstSelectedDay !== 0 && lastSelectedDay !== 0) {
                    dayButtons.forEach((e) => {
                        const day = Number(e.innerText);
                        if (day > firstSelectedDay && day < lastSelectedDay) {
                            e.parentNode.classList.toggle("gray");
                        }
                    });
                }

                if (firstSelectedDay !== 0 && lastSelectedDay !== 0) {
                    dayButtons.forEach((e) => {
                        const day = Number(e.innerText);
                        if (day == firstSelectedDay) {
                            e.parentNode.classList.toggle("gray2");
                        }
                    });
                }

                if (firstSelectedDay !== 0 && lastSelectedDay !== 0) {
                    dayButtons.forEach((e) => {
                        const day = Number(e.innerText);
                        if (day == lastSelectedDay) {
                            e.parentNode.classList.toggle("gray3");
                        }
                    });
                }


                if (firstSelectedDay > lastSelectedDay) {
                    dayButtons.forEach((e) => {
                        e.parentNode.classList.remove("gray");
                    });
                }

                
            });
        });


        dayButtons.forEach((element) => {
            element.addEventListener("mouseenter", (event) => {
                event.target.classList.add("day_hover")
            });
        });

        dayButtons.forEach((element) => {
            element.addEventListener("mouseleave", (event) => {
                event.target.classList.remove("day_hover")
            });
        });
    }



    handleEvents() {
        this.drawCalendar();
        this.updateCalendarStyle();
    }

}


const cal = new Calendar();
cal.handleEvents();