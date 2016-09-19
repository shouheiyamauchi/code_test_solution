# Donesafe Code Test

## A few notes about this test
This test is here to give people an opportunity to show off their skills.  It isn't supposed to be super realistic and it isn't supposed to be super strenuous to you as a candidate.   You should be spending a bit of time on this but if you've suddenly found yourself spending too long (too long varies by individual so I'm loathe to give a guide here but let's say if you're over eight hours then you might want to talk to us.) on it get in contact at <careers@donesafe.com> and talk to us about it.  There are a few things to point out:
* We have an implementation of this code already, so don't get bound up in production issues
* We don't mind what language and/or framework you use, if its code we should be geek enough to get it.  Though please feel free to explain your architectural choices :)
* This is about your thinking, we love to see your thinking
* Have some fun, be creative ;)
* Engineering values like TDD are important to us, so they should be evident in your submission


## Background
Here at Donesafe there are a couple of important numbers that our customers live on.  One of the most sensitive numbers is the calculation of [worker's compensation][1].  Ia particular there is a calculation called [PIAWE][2].  PIAWE is the way we work out how much someone who is unable to work gets paid.  In this case we have four people (found in people.json) who need payments.  PIAWE is a confusing and difficult thing for both employees and employers but for the purposes of this code test you'll be pleased to know we're gong to simplify things a bit :)  There's a sliding scale of payments based on how long you've been injured, and how you get paid (you'll find that in rules.json).  Our job as Donesafe is to make sure the worker is getting the right money.  It's also to make sure the employer is fulfilling her obligations to the employee and regulatory authorities.

We picked this problem because it's indicative of life at Donesafe, there's some number crunching but a lot of this is helping people navigate a complex problem.  Our users are usually not developers, in many cases they don't see computers as a big part of their job.  So if you're thinking about interface think about what's a good way to talk to people who aren't likely to be comfortable around computers.

## The tasks
There's a few to chose from here so you can choose, but clearly you need to do at least one :)

* How much do each of the injured people in people.json need to paid this week?
* Can you calculate and list their payments from each of their injuries over time?
* One of these people going to get significantly less than the others, can you a) work out who it is? and b) imagine they don't know and prepare a notification to send them?

## Questions
OK, we *think* that should be enough to get you rolling.  However we are always happy to work on it, so if something doesn't make sense hit us up on <careers@donesafe.com> and we'll work it through with you.

[1]: https://www.fairwork.gov.au/leave/workers-compensation "Fairwork Australia Workers Compensation Page"
[2]: http://www.worksafe.vic.gov.au/injury-and-claims/compensation-and-entitlements/weekly-payments-and-current-work-capacity
