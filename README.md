# EzDrive: An iOS platform for car-sharing

This repo holds the source code for a project completed for NUS Orbital Program held during the summer of 2018.
Embarassingly, there are no commits for this project because at the time of creating this application, I was not yet 
familiar with source control and thus did not use it for this project. However, for the purpose of displaying the 
past projects that I have completed and to show the type of code I have written, I decided to put this on GitHub.

## Introduction

EzDrive is an iOS application that aims to provide an easy and simple to use car-sharing platform for car owners in Singapore. 
We found that there are many car owners in Singapore, yet not fully utilising the car at times. With cars being notoriously 
expensive here, there are also many drivers that do not personally own cars. This application was created with the idea of 
connecting these two groups of people to allow car sharing to take place.

There are two main user types in this application, namely car owners and car renters. Car owners can post their cars on the 
app when they wish to rent it out, specifying their car type and model, period of loan, photos of the car and some other 
general information. Car renters can easily browse through available cars on the application, select whichever one they are 
interested in renting and the exchange can happen entirely on the application. 

## Information

This project was built entirely in Swift 4.0. The UI was built 100% programmatically with auto layout and constraints, with no storyboards or interface builder. Backend used is Firebase Database and no other third-party libraries were used.

## Features

### Login/Registration

Our app features a simple sign-in and sign-out functionality using Firebase Authentification. Users would have to register using an email and password, and will also login with an email and password. We also chose to take down more information regarding the user such as his name, location, a preferred username and also a profile picture. User is automatically logged in once registration is complete. 

<img src="/docs/ezdrive_login.jpg" alt="login" width="200"/>

### Sorting and Filtering of posts

Upon logging in, users are immediately presented with the Browse tab of the application, which displays all the cars that other users have already shared in the app. Users can sort posts via their location, which we have currently limited to just North, South, East, West and Central Singapore for simplicity. Sorting by price and date of post is also possible, as is filtering by car model. We have also limited the car models for simplicity. This can easily be expanded to include all car models in future development.

<img src="/docs/ezdrive_browse.jpg" alt="browse" width="200"/>

### New post

Users can create a new post when they wish to put their car available for sharing through the Share tab. The share tab requires the user to input some basic details regarding their car, including photos, brand and model, location, price, etc. Users are also required to input their car plate number, which is kept private, but used as a primary defense against bogus posts. Invalid car plate numbers will be rejected and the user will not be allowed to proceed with the post. The car plate number is checked against actual Singapore vehicle registration plate checksum. More info on the [wiki page](https://en.wikipedia.org/wiki/Vehicle_registration_plates_of_Singapore).

<img src="/docs/ezdrive_share.jpg" alt="share" width="200"/>

### Searching of posts

Users can navigate to the search tab and input a custom search query for their desired car. The search feature works in such a way that as users are inputting their search query, the posts are automatically filtered when whatever term they are searching for appears in the post's title. The following code segment shows how this is done:

<img src="/docs/ezdrive_search1.png" alt="search1" width="200"/>   <img src="/docs/ezdrive_search2.png" alt="search2" width="200"/>


##### Implementation

```swift
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredPosts = self.posts
        } else {
            self.filteredPosts = self.posts.filter { (post) -> Bool in
                return post.title.lowercased().contains(searchText.lowercased()) || post.description.lowercased().contains(searchText.lowercased())
            }
            self.filteredPosts = self.filteredPosts.sorted(by: { (post1, post2) -> Bool in
                return post1.timestamp > post2.timestamp
            })
        }
        self.collectionView?.reloadData()
    }
```


### User-to-user Chat

When a user is interested in a particular post, clicking on the post brings him to the main view of that single post, where 
there is an option for the user to initiate a chat. In the chat view, users can send a text message to the owner of the post just like any other messaging application. The owner of the post will then receive the message in his inbox and he can then reply on the spot. The messaging happens in real time. 

This was admittedly one of the harder features to implement due to the lack of suitable and up-to-date third party libraries that could provide us with a customisable message controller. We had to do this completely from scratch and encountered a lot of problems with storing the messages in the database, fetching the correct messages for the correct users and post, and rendering out the message in a clean and aesthetic manner.

<img src="/docs/ezdrive_chat.png" alt="chat" width="200"/>

##### Implementation

In the end, on the database side of things, we decided to structure our data in the following manner (Firebase is a NoSQL database):

```
<chatrooms>
|-- <postId>_<user1Uid>_<user2Uid>
    |-- <messageId>
        |-- <fromUid>
        |-- <toUid>
        |-- <timestamp>
        |-- <content>
    |-- <messageId>
        |-- <fromUid>
        |-- <toUid>
        |-- <timestamp>
        |-- <content>
```

This allowed us to have a unique chatroom for every single post and between every single unique user.

There was an interesting problem that we had to get around when using this idea - we had to make sure that when pushing the data to the database, the sequence of `user1Uid` and `user2Uid` must always be the same and reproducible. We got around this by putting the lexicographically smaller one in front.

### User Profile page and review

The profile page of the user simply presents the posts belonging to the current user as well as his reviews and other information. The current user is also able to browse the profile pages of other users by navigating through the posts on the main browse page, and can subsequently leave reviews on their pages.

<img src="/docs/ezdrive_profile.jpg" alt="profile" width="200"/>
