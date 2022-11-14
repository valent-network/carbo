# recar.io Server

- Serve mobile API requests
- Save Ads from different [Providers](https://github.com/viktorvsk/borax)
- Find friends-of-friends ([6 degrees of separation](https://en.wikipedia.org/wiki/Six_degrees_of_separation)) using [redisgraph](https://redis.com/modules/redis-graph/)
- Send authentication SMS (using [TurboSMS](https://github.com/vitalikdanchenko/turbosms)) and regular push notifications
- Run basic analytics of User interactions
- Build complex material views for better performance
- [Budget](https://recar.io/budget/10000) mini-project to get surface understanding of prices of used cars in Ukraine and help figuring out what car model could you be interested in
- Create simple ChatRooms (with the help of ActionCable) to discuss Ad you liked with friends who can help you to connect with Ad author
- Monitor main records using ActiveAdmin

Standard Rails project:
- Ruby 3.2
- Rails 7
- Sidekiq 7
- PostgreSQL 14


## Installaion

Refer to `.env.example` to set proper ENV variables.
