Original App Design Project - Samantha
===

# GIFTER

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Gifter allows you to input your friends' interests, as well as your budgets, and suggests products on the internet that could be fabulous presents for them. 

Right now, planning not to have interaction between people in the app (ie. allow people to input their own interests and suggest gift ideas for themselves). Idea is that people will be surpised, could change.

APIs: 
https://rapidapi.com/cristiandasilvaapps/api/amazon-search/
https://rapidapi.com/ApisbyET/api/search-walmart/

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Lifestyle, Shopping
- **Mobile:** Mobile allows for shopping and gift planning on the go. Can track location to suggest gift ideas from shops close to the user. The app updates real time with items for sale online.
- **Story:** Suggests products on the internet that could make great gifts for friends based on their likes and interests.
- **Market:** Anyone who regularly gives presents or struggles to come up with gift ideas can enjoy this app. Ability to see details and links to buy the suggested items.
- **Habit:** Users can shop throughout the day. Meant to be used when time is short and birthdays or holidays are coming up quickly, or to supplement their searching elsewhere.
- **Scope:** App has a clearly defined scope and purpose - gift suggesting - and would still be interesting and feasible to build with only the main features.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login (and logout)
* User can create a new account
* User can add friends
* User can add "interests" to friends
* User can see a suggested list of products for each friend
* User can click on products to see a more detailed view (including link to buy)
* User can scroll through a main products screen and add any product to a friend's list

**Optional Nice-to-have Stories**

* User can input a budget for each friend
* User can star products for each friend (appear at the top of list)
* User can search the main products screen
* User can input friends' ages

### 2. Screen Archetypes

* Login Screen
   * User can login (and logout)
* Registration Screen
   * User can create a new account
* Main Stream
    * User can scroll through a main products screen and add any product to a friend's list
    * (OPT) User can search the main products screen
* Friends Screen
    * User can see and click on their list of friends
* Add/Modify Friend Screen
    * User can add "interests" to friends
    * (OPT) User can input friends' ages
    * (OPT) User can input a budget for each friend
* Friend Specific Stream
    * User can see a suggested list of products for each friend
    * (OPT) User can star products for each friend (appear at the top of list)
* Details Screen
    * User can click on products to see a more detailed view (including link to buy)


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Main Stream
* Friends Screen

**Flow Navigation** (Screen to Screen)

* Login Screen
   * => Main Stream
* Registration Screen
   * => Main Stream
* Main Stream
   * => Details Screen
* Friends Stream
   * => Add/Modify Friend Screen
   * => Friend Specific Stream
* Add/Modify Friend Screen
   * => Friends Screen (after finished modifying)
* Friend Specific Stream
   * => Details Screen
* Details Screen
   * => None (except product links to outside)



## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
