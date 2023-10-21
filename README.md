# StudyPal
Hi Jason!

### Whats been done so far
* App compiles with a working UI that has a few secondary buttons and allows you to click between the 4 main tabs. Fire it up and take a look! You should arrive on a screen with a "Log In" button once the app is fully started up.
* Serverside API currently handles the scrapping of the UVM Schedule of Courses. Server is run on swift, and the API can by used over HTTP requests with a query. Returns JSON file of what matches the query. Try it out:
https://one.ehinchli.w3.uvm.edu/api/courses/search/?query=mobile
* A basic example of how Swift will call the API has been built, but it features no processing yet.
(UVM-StudyPal/APICalls.swift)
* While they are not functionally implemented into the app yet, a set of Parent/Child classes covering Courses, Study Blocks, and Custom events has been written and now just needs to be expanded to work with the API and UI.
(UVM-StudyPal/CalendarItems.swift, CourseItems.swift, StudyItems.swift, CustomItems.swift)

### To-Do Lists till next Deliverable
- [ ] Process JSON file returned by API calls, turn it into data struct

- [ ] Create serverside account/login system

- [ ] Further implement the UI, getting at least the calendar tab working

- [ ] Implement the other 3 tabs 

## Submission Schedule
- [X] First Deliverable Oct. 7th - PDF

- [X] Second Deliverable Oct. 21st - Something that vaguely runs as an app

- [ ] Third Deliverable Sometime in Nov. - Something that is mostly functional

- [ ] Final Deliverable Dec. 2nd - Final touches and polish
