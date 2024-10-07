---
layout: blog-post 
title:  "How I Improved My Chess Elo with Python"
date:   2023-11-02
---
I’ve been playing chess on Lichess for the past 2 years to improve my chess skills. Over that time I’ve seen an increase in my elo of over 900!

However, over the past few months that growth has become stagnant, and I’ve been stuck just below the rating of 1900 elo.
![image tooltip here](/img/posts/2023-11-02/highest_elo.png)

I knew that studying my chess openings would be the only way to cross this threshold, but that seemed like a lot of manual work. Luckily, I know a bit of Python.

I started by creating a [GitHub repository](https://github.com/joeyagreco/daily-chess) to store my code. I then looked at Lichess’ [API documentation](https://lichess.org/api) and found that they have endpoints that allow users to retrieve games by username... just what I needed.

Using [Postman](https://www.postman.com/), I sent a few requests to the Lichess API to see what filters I would need and how they format their responses.
