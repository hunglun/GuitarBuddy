//
//  SCConstants.swift
//  p5
//
//  Created by hunglun on 3/2/16.
//  Copyright © 2016 hunglun. All rights reserved.
//

// MARK: Parameter Keys
extension Soundcloud {

    // MARK: Constants
    struct Constants {

        // MARK: API Keys
        static let clientId = "fdf75eddcd987c3e6beb9b3a47925633"
        static let clientSecret = "dfd72e17039500100a3b5bd0be3cb9b0"

        
        // MARK: URLs
        static let AuthorizationURL : String = "https://soundcloud.com/connect"
        static let SoundcloudSecureBaseUrl = "https://api.soundcloud.com/"
        
    }

    // MARK: Parameter keys
    struct ParameterKeys {
    
        static let AccessToken = "oauth_token"

    
    }
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let UserIdTracks = "users/{id}/tracks"
        static let UserProfile = "me"
        static let AccountIDWatchlistMovies = "account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "authentication/token/new"
        static let AuthenticationSessionNew = "authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "search/movie"
        
        // MARK: Config
        static let Config = "configuration"
        
    }

    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Tracks
        static let TrackID = "id"
        static let TrackTitle = "title"
        static let TrackPosterPath = "poster_path"
        static let TrackReleaseDate = "release_date"
        static let TrackReleaseYear = "release_year"
        static let TrackResults = "results"
        
    }

    

}
