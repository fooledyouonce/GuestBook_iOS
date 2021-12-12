# GuestBook_iOS

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Project Setup](#Project-Setup)
5. [Demo](#Demo)

## Overview
### Description
This application acts as a digital guestbook for event such as weddings, baby showers, birthday parties and more.
Users will be able to either create an event or sign up for an event. Within these events, users can upload photos,
videos, and text that will be displayed to the event's timeline.

### App Evaluation
- **Category:** Social Media
- **Mobile:** Mobile allows for convenient use of this app. Users will be able to use the camera to take pictures
	      of the event they are at as well as easily upload any photos/videos from their phone. They can also use
	      the map feature to "tag" locations.
- **Story:** Allows for a digitalized, mobile, and compact guestbook that can be easily accessed from anywhere by the
             desired party.
- **Market:** Any person hosting an event who wishes to keep a guestbook. Especially marketed towards weddings and 
              baby showers.
- **Habit:** Event hosts can easily set this up for their events and guests can access the events at any time to upoad content.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* User can create a new account
* User can create an event
* User can edit event details
* User can post a picture/video/text message
* User can view a feed of media

**Optional Nice-to-have Stories**

* Users can join an active event
* Users can view past events

### 2. Screen Archetypes

* Login Screen
   * User can login
* Account Registration Screen
   * User can create a new account
* Home Screen
   * Lists event creation and event registration options
* Event Creation Screen
   * User can create a new event
   * User can input event details
* Event Registration Screen
   * User can register for an event
* Event Stream
   * User can view a feed of photos/videos/text
   * User can see tagged locations for media
* Creation
   * User can post a photo/video/text message
* Past Events
   * User can view past event guestbooks

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Past Events
* Logout

**Flow Navigation** (Screen to Screen)

* Login Screen
   => Home
* Registration Screen
   => Home
* Home Screen
   => Login Screen
   => Create Event
   => Join Event
   => Past Events
* Timeline
   => Home Screen
   => Edit Details
* Creation
   => Timeline
* Edit Details/Create Event
   => Home
   => Timeline
* Event Registration
   => Home
   => Timeline
* Past Events
   => Home
   => Timeline

## Wireframes
<img src="GBWFHost.png" width=600>

## Project Setup

This application only works properly when connected to a Firebase RealTime database.

## Demo

## Click here for the project demo: https://www.youtube.com/watch?v=sbUam79TCUU
