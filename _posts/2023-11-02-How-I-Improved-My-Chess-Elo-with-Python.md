---
layout: blog-post 
title:  "How I Improved My Chess Elo with Python"
date:   2023-11-02
---
I’ve been playing chess on Lichess for the past 2 years to improve my chess skills. Over that time I’ve seen an increase in my elo of over 900!

However, over the past few months that growth has become stagnant, and I’ve been stuck just below the rating of 1900 elo.

![Highest rating of 1895](/img/posts/2023-11-02/highest_elo.png)

I knew that studying my chess openings would be the only way to cross this threshold, but that seemed like a lot of manual work. Luckily, I know a bit of Python.

I started by creating a [GitHub repository](https://github.com/joeyagreco/daily-chess) to store my code. I then looked at Lichess’ [API documentation](https://lichess.org/api) and found that they have endpoints that allow users to retrieve games by username... just what I needed.

Using [Postman](https://www.postman.com/), I sent a few requests to the Lichess API to see what filters I would need and how they format their responses.

![Postman request and response](/img/posts/2023-11-02/postman.png)

I knew the following:

- I wanted only rated games
- I wanted only Blitz games
- I wanted the games sorted from most to least recent
- I wanted the name of the opening for each game

Using the query parameters outlined in the documentation, I found that I would need a URL like this:

```sh
https://lichess.org/api/games/user/drcoffeeki11?rated=true&perfType=blitz&sort=dateDesc&opening=true&finished=true&tags=true&max=100
```

Now that I knew where I could get the data I needed, it was time to code!

I won’t walk you through all of the code (you can take a look at it here), but the main flow of it looks like this:

1. Define environment variables for my use case

    ```sh
    LICHESS_USERNAME=drcoffeeki11
    NUM_GAMES=100
    PERF_TYPE=blitz
    RUN_AT_TIME=10:00
    DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/12345/abcdefg
    DISCORD_DAILY_OPENINGS_TO_SEND=3
    ```

2. Extract the net elo in the past 100 games for each opening and save the game URLs

    ```py
    openings_and_net_elo = defaultdict(float)          # store net elo for each opening
    openings_and_game_urls: dict[str, list[str]] = {}  # store game URLs for each opening
    for game in games:
        if game.opening_name not in openings_and_game_urls.keys():
            openings_and_game_urls[game.opening_name] = []
        openings_and_net_elo[game.opening_name] += game.elo_for_user(USERNAME)
        if game.winner_username != USERNAME:           # I tied or lost, save this game URL
            openings_and_game_urls[game.opening_name].append(game.game_url)
    openings_and_net_elo = dict(openings_and_net_elo)
    ```

3. Send the results every morning to a private Discord server via a [webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)


    ```py
    @classmethod
    def send_webhook(cls, *, url: str, embeds: list[dict]) -> None:
        data = {"embeds": embeds}
        cls._rest_call(requests.post, url, json=data)
    ```
    ```py
    if __name__ == "__main__":
        schedule.every().day.at(EnvironmentReader.get("RUN_AT_TIME")).do(main)

        while True:
            schedule.run_pending()
            time.sleep(1)
    ```

When run, the code ends up sending messages that look like this…

![Discord message 1](/img/posts/2023-11-02/discord_message_1.png)

![Discord message 2](/img/posts/2023-11-02/discord_message_2.png)

![Discord message 3](/img/posts/2023-11-02/discord_message_3.png)

![Discord message 4](/img/posts/2023-11-02/discord_message_4.png)

…to a private Discord server I’m in.

Now every morning when I receive these messages, I can click the links to the games whose openings I struggle with the most, and study the positions with Stockfish right on Lichess’ website!

![Lichess](/img/posts/2023-11-02/lichess.png)

The last step was to build this into a [Docker container](https://www.docker.com/resources/what-container/) so I could run it on my [Unraid](https://unraid.net/) server and not have to worry about it constantly running on my personal computer.

![Unraid](/img/posts/2023-11-02/unraid.png)

And that’s it! 1900 here I come 🚀
