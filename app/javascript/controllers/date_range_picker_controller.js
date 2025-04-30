import { Controller } from "@hotwired/stimulus"
import * as VCP from 'vanilla-calendar-pro';

// Connects to data-controller="date-range-picker"
export default class extends Controller {

  static targets = [ "calendar", "startDate", "endDate", "startDateDisplay", "endDateDisplay" ]

  connect() {
    console.log("pika pika")
    console.dir(this.startDateDisplayTarget)
    const options = {
      type: 'default',
      displayMonthsCount: 1,
      selectionDatesMode: 'multiple-ranged',
      disableDatesPast: true,

      onClickDate: (self) => {
        console.log(self.context.selectedDates);

        if (self.context.selectedDates.length == 2) {
          console.log(self.context.selectedDates[0])
          this.startDateDisplayTarget.innerText = self.context.selectedDates[0];
          this.endDateDisplayTarget.innerText = self.context.selectedDates[1]
        }
      },

      locale: 'fr', 
    };

    const calendar = new VCP.Calendar(this.calendarTarget, options);

    calendar.init();
  }

  disconnect() {
    calendar.destroy(); 
  }

}
