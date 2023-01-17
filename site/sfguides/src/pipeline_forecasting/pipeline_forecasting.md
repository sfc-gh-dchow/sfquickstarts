author: Daniel Chow
id: pipeline_forecasting
summary: A guide to get a basic Pipeline Forecasting up and running.
categories: Getting Started
environments: web
status: Published 
feedback link: https://github.com/Snowflake-Labs/sfguides/issues
tags: Getting Started, Data Science, Data Engineering, Twitter 

# Pipeline Forecasting
<!-- ------------------------ -->
## Overview 
Duration: 1

Please use [this markdown file](https://raw.githubusercontent.com/Snowflake-Labs/sfguides/master/site/sfguides/sample.md) as a template for writing your own Snowflake Quickstarts. This example guide has elements that you will use when writing your own guides, including: code snippet highlighting, downloading files, inserting photos, and more. 

It is important to include on the first page of your guide the following sections: Prerequisites, What you'll learn, What you'll need, and What you'll build. Remember, part of the purpose of a Snowflake Guide is that the reader will have **built** something by the end of the tutorial; this means that actual code needs to be included (not just pseudo-code).

The rest of this Snowflake Guide explains the steps of writing your own guide. 

### Prerequisites
* Completion of the [Getting Started with Snowpark for Python](https://quickstarts.snowflake.com/guide/getting_started_snowpark_machine_learning/#0) Quickstart
* Working knowledge of Python
* Familiarity with Snowflake
* Familiarity with Docker, Apache Airflow

### What You’ll Learn 
* How to create a bottom up pipeline forecast model
* How to setup an Extract, Load and Transform (ELT) pipeline in Python for both bulk ingestion of ~100m time series records using the Snowpark Python Client API as well as an incremental load process.
* How to perform exploratory data analysis , model development, experimentation and feature engineering using Snowflake and Python
* How to create a reproducible, monitored, explainable and automated pipeline for machine learning training and inference at very large scale.
* How to implement end-to-end machine learning workflows in Snowflake with Python which can be orchestrated with dbt, Airflow, or any other python-capable orchestration framework.

### What You’ll Need 
* A Snowflake Account with Anaconda Integration enabled by ORGADMIN - if you do not already have a Snowflake account, you can register for a free trial account

*Note: If you are planning to run this Quickstart locally, you may have additional requirements, e.g. Docker, Miniconda. Take a look at the source code README for more information on additional local environment requirements.*

### What You’ll Build 
* An orchestrated end-to-end Machine Learning pipeline to perform monthly forecasts using Snowflake, Snowpark Python, PyTorch, and Apache Airflow.



<!-- ------------------------ -->
## Use-Case: B2B Sales Pipeline Forecasting
Duration: 2

Building and managing sales pipeline is a key responsibility for B2B sales and marketing organizations. In this Snowflake Quickstart we’d like to share with you some insights that we’ve learned from building our own in-house forecasting application so that you can accelerate your adoption of this type of modeling. Our focus will be on two key metrics: Day 1 Sales Pipeline and Closed Won Pipeline.
 At Snowflake Day 1 Sales Pipeline is a key metric that our marketing organization manages to and represents the total amount of sales pipeline that we start a fiscal quarter with. Our marketing organization works to set our sales team up for success by generating demand for Snowflake that leads to the creation and acceleration of opportunities. 
Closed Won Pipeline is when our sales team gets a contract signed and a prospect becomes a Snowflake customer or an existing Customer renews with Snowflake. We also refer to this as “Bookings”. 
To arrive at our Day 1 Pipeline and Closed Won Pipeline forecasts we use a bottom up model that uses machine learning to determine how much we will get from our in-progress pipeline and how much new pipeline we will generate before the target period.

<!-- ------------------------ -->
## Creating a Step
Duration: 2

A single sfguide consists of multiple steps. These steps are defined in Markdown using Header 2 tag `##`. 

```markdown
## Step 1 Title
Duration: 3

All the content for the step goes here.

## Step 2 Title
Duration: 1

All the content for the step goes here.
```

To indicate how long each step will take, set the `Duration` under the step title (i.e. `##`) to an integer. The integers refer to minutes. If you set `Duration: 4` then a particular step will take 4 minutes to complete. 

The total sfguide completion time is calculated automatically for you and will be displayed on the landing page. 

<!-- ------------------------ -->
## Code Snippets, Info Boxes, and Tables
Duration: 2

Look at the [markdown source for this sfguide](https://raw.githubusercontent.com/Snowflake-Labs/sfguides/master/site/sfguides/sample.md) to see how to use markdown to generate code snippets, info boxes, and download buttons. 

### JavaScript
```javascript
{ 
  key1: "string", 
  key2: integer,
  key3: "string"
}
```

### Java
```java
for (statement 1; statement 2; statement 3) {
  // code block to be executed
}
```

### Info Boxes
Positive
: This will appear in a positive info box.


Negative
: This will appear in a negative info box.

### Buttons
<button>
  [This is a download button](link.com)
</button>

### Tables
<table>
    <thead>
        <tr>
            <th colspan="2"> **The table header** </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>The table body</td>
            <td>with two columns</td>
        </tr>
    </tbody>
</table>

### Hyperlinking
[Youtube - Halsey Playlists](https://www.youtube.com/user/iamhalsey/playlists)

<!-- ------------------------ -->
## Images, Videos, and Surveys, and iFrames
Duration: 2

Look at the [markdown source for this guide](https://raw.githubusercontent.com/Snowflake-Labs/sfguides/master/site/sfguides/sample.md) to see how to use markdown to generate these elements. 

### Images
![Puppy](assets/SAMPLE.jpg)

### Videos
Videos from youtube can be directly embedded:
<video id="KmeiFXrZucE"></video>

### Inline Surveys
<form>
  <name>How do you rate yourself as a user of Snowflake?</name>
  <input type="radio" value="Beginner">
  <input type="radio" value="Intermediate">
  <input type="radio" value="Advanced">
</form>

### Embed an iframe
![https://codepen.io/MarioD/embed/Prgeja](https://en.wikipedia.org/wiki/File:Example.jpg "Try Me Publisher")

<!-- ------------------------ -->
## Conclusion
Duration: 1

At the end of your Snowflake Guide, always have a clear call to action (CTA). This CTA could be a link to the docs pages, links to videos on youtube, a GitHub repo link, etc. 

If you want to learn more about Snowflake Guide formatting, checkout the official documentation here: [Formatting Guide](https://github.com/googlecodelabs/tools/blob/master/FORMAT-GUIDE.md)

### What we've covered
- creating steps and setting duration
- adding code snippets
- embedding images, videos, and surveys
- importing other markdown files