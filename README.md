# AI Book Bot (ReadAI)
## Project Idea
I am an avid reader and my project idea was highly based around this. I wanted to create an app that utilizes AI that helps my hobby of reading and that's what I did. This app lets you search up books by ISBN and gives you a basic run down on the book's information. It tells you who made it, how many pages this book contains and most importantly it gives you an AI summary of the book. The app also contains other tabs that generate book suggestions/recommendations pertaining to the tabs category and gives you the same type of book information overview.
The two main API's I utilized in this project was the [OpenLibrary API](https://openlibrary.org/developers/api) which is where I would get basic book information through ISBN's and titles and the other is the [OpenAI API](https://platform.openai.com/docs/overview) where I would get the recommendations and summarys for books.

## Demo
[![Demo Video](https://img.youtube.com/vi/0TZtA7CA3fg/0.jpg)](https://www.youtube.com/watch?v=0TZtA7CA3fg)

## UI
![IMG_0747](https://github.com/user-attachments/assets/33f8000c-b8c4-4616-9a5b-81342cc3c091)

## Features:
### Must Have Features:
- Retreive book information through ISBN(2-3 hours)
- Functioning tab biew for categories(1-2 hours)
- Organize categories to have their own respective search(3-4 hours)
- Utilize OpenAI API to get book summaries(3-6 hours)
- Utilize OpenAI API to get book recommendations(2-3 hours)

### Nice to Have Features:
- Initial "recommend book" button for each category (to minimize API calls)(2 hours)
- Be able to change to dark/light mode(1 hours)
- Have an overlay for the project to view settings/extra features(1 hours)
- Be able to change GPT model through settings(1-2 hours)
- Be able to see recent searches(2-3 hours)
- Be able to see recent recommendations(2-3 hours)
- Be able to save searched/recommended books and view them later(2-3 hours)

## Project Reflection:
### What was fun about the project:
- Making something that I will actually utilize (motivated me to work on this project)
- Creating a nice UI, testing different fonts
- Getting a function to work after struggling a long time

### Obstacles during the project:
- Getting the OpenAI API to work
- Reading the Json book information
- Near the end of the project my Xcode no longer worked properly and my contentview preview simulator did not work (I was no longer able to work on the project)

## Build Instructions
1. Create a key.xcconfig file
2. Create a variable that holds the OpenAI API Key:
EXAMPLE: API_KEY = YOUR_KEY_WITH_NO_QUOTATION_MARKS
3. Click AI Book Bot's Target and go to the info tab
4. Click the "+" to create a new entry, and for key put "API_KEY" and for value put "$(API_KEY)"
5. Then go to app project and go to its info tab, then drop down both debug and release tabs
6. For both targets in debug and release select 'config'
7. You can now utilize the project
