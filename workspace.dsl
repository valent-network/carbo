workspace {

    model {
        user = person "User" "A user of my software system."
        
        appStore = softwareSystem "Apple AppStore" "" "Distribution"
        googlePlay = softwareSystem "Google Play" "" "Distribution"
        appCenter = softwareSystem "App Center" "" "Distribution"
        
        thridPartyAdsProviders = softwareSystem "3rd-party" "" "Support"
        
        # TODO: +sentry
        turboSMS = softwareSystem "SMS Provider" "TurboSMS" "External"
        s3 = softwareSystem "S3" "Digital Ocean Spaces" "Database"
        
        enterprise {
            recario = softwareSystem "recar.io" {
                ferrum = container "Ferrum" {
                    androidBuild = component "Android dist"
                    iosBuild = component "iOS dist"
                    hotUpdates = component "JS updates"
                    
                }
                carbo = container "Carbo" {
                    component "Sidekiq Workers"
                    component "Clockwork Scheduler"
                    carboAPI = component "Puma Web Server"
                    rpush = component "RPush Push Notifications Sender"
                    
                }
                borax = container "Borax" {
                    component "Sidekiq Workers"
                }
                
                postgres = container "PostgreSQL" "" "Database" {
                    component "Database Server"
                    component "Cron"
                    component "Backup Script"
                }
                redis = container "Redis" "" "Database"
                redisGraph = container "RedisGraph" "" "Database"
            }

            
        }

        user -> ferrum "Uses"
        
        ferrum -> carbo "Requests API"
        androidBuild -> carboAPI "Requests API"
        iosBuild -> carboAPI "Requests API"
        androidBuild -> googlePlay "Distributed to"
        iosBuild -> appStore "Distributed to"
        hotUpdates -> appCenter "Distributed to"
        
        borax -> redis "Populates Ads"
        borax -> thridPartyAdsProviders "Collects Ads"
        
        # TODO: +sentry
        carbo -> s3 "Saves User Avatars"
        carbo -> postgres "Stores Data"
        carbo -> redis "Sidekiq"
        carbo -> redisGraph "UserConnections data"
        carbo -> turboSMS "Auth OTP"
        rpush -> appStore "Sends Push Notifications"
        rpush -> googlePlay "Sends Push Notifications"
        
        appStore -> user "Push Notifications"
        googlePlay -> user "Push Notifications"
        appCenter -> user "Delivers JS updates"
        turboSMS -> user "Auth OTP"
        
        
    }

    views {

        
        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Support" {
                background #aaaaaa
            }
            element "Database" {
                shape Cylinder
            }
            element "Distribution" {
                shape Folder
                background #00935b
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
        }
    }

    
}