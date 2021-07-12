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
![Wireframes 2](https://user-images.githubusercontent.com/26338000/125311303-4fe7dd00-e301-11eb-843b-6978e77aa5e8.jpg)


### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models
User:
<table>
<thead>
  <tr>
    <th>Property</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>username</td>
    <td>String</td>
    <td>username of the user</td>
  </tr>
  <tr>
    <td>password</td>
    <td>String</td>
    <td>password of the user</td>
  </tr>
</tbody>
</table>

Friend:
<table>
<thead>
  <tr>
    <th>Property</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>name</td>
    <td>String</td>
    <td>name of the friend</td>
  </tr>
  <tr>
    <td>interests</td>
    <td>Array of Strings</td>
    <td>interests / likes of the friend that will be used to generate gift ideas</td>
  </tr>
  <tr>
    <td>budget</td>
    <td>Int</td>
    <td>amount that the user wants to spend on each friend</td>
  </tr>
  <tr>
    <td>image (optional)</td>
    <td>File</td>
    <td>picture of the friend</td>
  </tr>
</tbody>
</table>

Gift Suggestion / Product:
<table>
<thead>
  <tr>
    <th>Property</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>name</td>
    <td>String</td>
    <td>name of the gift suggestion</td>
  </tr>
  <tr>
    <td>description</td>
    <td>String</td>
    <td>description of the gift suggestion</td>
  </tr>
  <tr>
    <td>price</td>
    <td>Int</td>
    <td>cost of the gift suggestion</td>
  </tr>
  <tr>
    <td>image</td>
    <td>File</td>
    <td>picture of the gift suggestion</td>
  </tr>
  <tr>
    <td>link</td>
    <td>String</td>
    <td>link to to buy the gift suggestion on amazon / walmart / etc.</td>
  </tr>
</tbody>
</table>


### Networking

* Friends Stream
   * (Create/POST) Create a new friend object
* Add/Modify Friend Screen
   * (Read/GET) Query the current information for the selected friend
* Friend Specific Stream
   * (Read/GET) Query all of the friend's interests
   * (Read/GET) Find words related to friend's interests
   * (Read/GET) Query all products from keywords with the friend's interests + related words
   * (Create/POST) Create a new gift suggestion object for each product
* Details Screen
   * (Read/GET) Query the details for the selected gift suggestion

### Ways to Increase Algorithmic Complexity

* Generates products not just based on the friend's exact interests, but also on related keywords
   * Example: friend likes "hiking" - search not only for "hiking" but also for "camping gear", "mountain gear", "tent", etc. 
* Create gift baskets - app will generate a bunch of items that together add up to your budget for that friend, instead of showing each item seperately

  

