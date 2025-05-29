import { Controller } from "@hotwired/stimulus"
import * as VCP from 'vanilla-calendar-pro';

// Connects to data-controller="date-range-picker"
export default class extends Controller {

  static targets = [ "calendar", "startDate", "endDate", "startDateDisplay", "endDateDisplay", "bookingDuration" ]

  connect() {
    const options = {
      type: 'default',
      displayMonthsCount: 1,
      selectionDatesMode: 'multiple-ranged',
      disableDatesPast: true,

      onClickDate: (self) => {
        console.log(self.context.selectedDates);

        if (self.context.selectedDates.length == 2) {
          let startDate = new Date(self.context.selectedDates[0])
          let endDate = new Date(self.context.selectedDates[1])
          this.startDateTarget.value = self.context.selectedDates[0]
          this.endDateTarget.value = self.context.selectedDates[1]
          const duration = Math.abs(endDate - startDate)
          const durationDays = Math.ceil(duration / (1000 * 60 * 60 * 24))
          this.bookingDurationTarget.innerText = `Durée de la location : ${durationDays} jours.`
        }
      },

      locale: 'fr', 
    };

    const calendar = new VCP.Calendar(this.calendarTarget, options);

    calendar.init();
  }
}
