## TASK 2:- 

- Find out how many taxi companies there are in Chicago.

```
=COUNTUNIQUE(taxi_trips!company)
```

- Find the percentage of taxi rides in Chicago that included a tip.

```
=COUNTIF(taxi_trips!tips,">0")
```

- Find the total number of trips where the fare was greater than 0.

```
=COUNTIF(taxi_trips!fare,">0")
```


## Task 3.

* As a pie chart, what forms of payments are people using for their taxi rides?

* Drag payment_type to the Label field. Then drag fare into the Value field 

* Under Value > Fare, change Sum to Count. Click Apply.


