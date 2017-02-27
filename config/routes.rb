# == Route Map
#
# I, [2017-02-08T01:52:02.717571 #46]  INFO -- sentry: ** [Raven] Raven 2.2.0 configured not to capture errors: No server specified, No host specified, No path specified, No public_key specified, No secret_key specified, No project_id specified
#                                       Prefix Verb      URI Pattern                                                                          Controller#Action
#                                  rails_admin           /admin                                                                               RailsAdmin::Engine
#             library_entry_relationships_user GET       /edge/library-entries/:library_entry_id/relationships/user(.:format)                 library_entries#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/user(.:format)                 library_entries#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/user(.:format)                 library_entries#destroy_relationship {:relationship=>"user"}
#                           library_entry_user GET       /edge/library-entries/:library_entry_id/user(.:format)                               users#get_related_resource {:relationship=>"user", :source=>"library_entries"}
#            library_entry_relationships_anime GET       /edge/library-entries/:library_entry_id/relationships/anime(.:format)                library_entries#show_relationship {:relationship=>"anime"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/anime(.:format)                library_entries#update_relationship {:relationship=>"anime"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/anime(.:format)                library_entries#destroy_relationship {:relationship=>"anime"}
#                          library_entry_anime GET       /edge/library-entries/:library_entry_id/anime(.:format)                              anime#get_related_resource {:relationship=>"anime", :source=>"library_entries"}
#            library_entry_relationships_manga GET       /edge/library-entries/:library_entry_id/relationships/manga(.:format)                library_entries#show_relationship {:relationship=>"manga"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/manga(.:format)                library_entries#update_relationship {:relationship=>"manga"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/manga(.:format)                library_entries#destroy_relationship {:relationship=>"manga"}
#                          library_entry_manga GET       /edge/library-entries/:library_entry_id/manga(.:format)                              manga#get_related_resource {:relationship=>"manga", :source=>"library_entries"}
#            library_entry_relationships_drama GET       /edge/library-entries/:library_entry_id/relationships/drama(.:format)                library_entries#show_relationship {:relationship=>"drama"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/drama(.:format)                library_entries#update_relationship {:relationship=>"drama"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/drama(.:format)                library_entries#destroy_relationship {:relationship=>"drama"}
#                          library_entry_drama GET       /edge/library-entries/:library_entry_id/drama(.:format)                              dramas#get_related_resource {:relationship=>"drama", :source=>"library_entries"}
#           library_entry_relationships_review GET       /edge/library-entries/:library_entry_id/relationships/review(.:format)               library_entries#show_relationship {:relationship=>"review"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/review(.:format)               library_entries#update_relationship {:relationship=>"review"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/review(.:format)               library_entries#destroy_relationship {:relationship=>"review"}
#                         library_entry_review GET       /edge/library-entries/:library_entry_id/review(.:format)                             reviews#get_related_resource {:relationship=>"review", :source=>"library_entries"}
#            library_entry_relationships_media GET       /edge/library-entries/:library_entry_id/relationships/media(.:format)                library_entries#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/media(.:format)                library_entries#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/media(.:format)                library_entries#destroy_relationship {:relationship=>"media"}
#                          library_entry_media GET       /edge/library-entries/:library_entry_id/media(.:format)                              media#get_related_resource {:relationship=>"media", :source=>"library_entries"}
#             library_entry_relationships_unit GET       /edge/library-entries/:library_entry_id/relationships/unit(.:format)                 library_entries#show_relationship {:relationship=>"unit"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/unit(.:format)                 library_entries#update_relationship {:relationship=>"unit"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/unit(.:format)                 library_entries#destroy_relationship {:relationship=>"unit"}
#                           library_entry_unit GET       /edge/library-entries/:library_entry_id/unit(.:format)                               units#get_related_resource {:relationship=>"unit", :source=>"library_entries"}
#        library_entry_relationships_next_unit GET       /edge/library-entries/:library_entry_id/relationships/next-unit(.:format)            library_entries#show_relationship {:relationship=>"next_unit"}
#                                              PUT|PATCH /edge/library-entries/:library_entry_id/relationships/next-unit(.:format)            library_entries#update_relationship {:relationship=>"next_unit"}
#                                              DELETE    /edge/library-entries/:library_entry_id/relationships/next-unit(.:format)            library_entries#destroy_relationship {:relationship=>"next_unit"}
#                      library_entry_next_unit GET       /edge/library-entries/:library_entry_id/next-unit(.:format)                          next_units#get_related_resource {:relationship=>"next_unit", :source=>"library_entries"}
#                              library_entries GET       /edge/library-entries(.:format)                                                      library_entries#index
#                                              POST      /edge/library-entries(.:format)                                                      library_entries#create
#                                library_entry GET       /edge/library-entries/:id(.:format)                                                  library_entries#show
#                                              PATCH     /edge/library-entries/:id(.:format)                                                  library_entries#update
#                                              PUT       /edge/library-entries/:id(.:format)                                                  library_entries#update
#                                              DELETE    /edge/library-entries/:id(.:format)                                                  library_entries#destroy
#                   anime_relationships_genres GET       /edge/anime/:anime_id/relationships/genres(.:format)                                 anime#show_relationship {:relationship=>"genres"}
#                                              POST      /edge/anime/:anime_id/relationships/genres(.:format)                                 anime#create_relationship {:relationship=>"genres"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/genres(.:format)                                 anime#update_relationship {:relationship=>"genres"}
#                                              DELETE    /edge/anime/:anime_id/relationships/genres(.:format)                                 anime#destroy_relationship {:relationship=>"genres"}
#                                 anime_genres GET       /edge/anime/:anime_id/genres(.:format)                                               genres#get_related_resources {:relationship=>"genres", :source=>"anime"}
#                 anime_relationships_castings GET       /edge/anime/:anime_id/relationships/castings(.:format)                               anime#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/anime/:anime_id/relationships/castings(.:format)                               anime#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/castings(.:format)                               anime#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/anime/:anime_id/relationships/castings(.:format)                               anime#destroy_relationship {:relationship=>"castings"}
#                               anime_castings GET       /edge/anime/:anime_id/castings(.:format)                                             castings#get_related_resources {:relationship=>"castings", :source=>"anime"}
#             anime_relationships_installments GET       /edge/anime/:anime_id/relationships/installments(.:format)                           anime#show_relationship {:relationship=>"installments"}
#                                              POST      /edge/anime/:anime_id/relationships/installments(.:format)                           anime#create_relationship {:relationship=>"installments"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/installments(.:format)                           anime#update_relationship {:relationship=>"installments"}
#                                              DELETE    /edge/anime/:anime_id/relationships/installments(.:format)                           anime#destroy_relationship {:relationship=>"installments"}
#                           anime_installments GET       /edge/anime/:anime_id/installments(.:format)                                         installments#get_related_resources {:relationship=>"installments", :source=>"anime"}
#                 anime_relationships_mappings GET       /edge/anime/:anime_id/relationships/mappings(.:format)                               anime#show_relationship {:relationship=>"mappings"}
#                                              POST      /edge/anime/:anime_id/relationships/mappings(.:format)                               anime#create_relationship {:relationship=>"mappings"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/mappings(.:format)                               anime#update_relationship {:relationship=>"mappings"}
#                                              DELETE    /edge/anime/:anime_id/relationships/mappings(.:format)                               anime#destroy_relationship {:relationship=>"mappings"}
#                               anime_mappings GET       /edge/anime/:anime_id/mappings(.:format)                                             mappings#get_related_resources {:relationship=>"mappings", :source=>"anime"}
#                  anime_relationships_reviews GET       /edge/anime/:anime_id/relationships/reviews(.:format)                                anime#show_relationship {:relationship=>"reviews"}
#                                              POST      /edge/anime/:anime_id/relationships/reviews(.:format)                                anime#create_relationship {:relationship=>"reviews"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/reviews(.:format)                                anime#update_relationship {:relationship=>"reviews"}
#                                              DELETE    /edge/anime/:anime_id/relationships/reviews(.:format)                                anime#destroy_relationship {:relationship=>"reviews"}
#                                anime_reviews GET       /edge/anime/:anime_id/reviews(.:format)                                              reviews#get_related_resources {:relationship=>"reviews", :source=>"anime"}
#      anime_relationships_media_relationships GET       /edge/anime/:anime_id/relationships/media-relationships(.:format)                    anime#show_relationship {:relationship=>"media_relationships"}
#                                              POST      /edge/anime/:anime_id/relationships/media-relationships(.:format)                    anime#create_relationship {:relationship=>"media_relationships"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/media-relationships(.:format)                    anime#update_relationship {:relationship=>"media_relationships"}
#                                              DELETE    /edge/anime/:anime_id/relationships/media-relationships(.:format)                    anime#destroy_relationship {:relationship=>"media_relationships"}
#                    anime_media_relationships GET       /edge/anime/:anime_id/media-relationships(.:format)                                  media_relationships#get_related_resources {:relationship=>"media_relationships", :source=>"anime"}
#                 anime_relationships_episodes GET       /edge/anime/:anime_id/relationships/episodes(.:format)                               anime#show_relationship {:relationship=>"episodes"}
#                                              POST      /edge/anime/:anime_id/relationships/episodes(.:format)                               anime#create_relationship {:relationship=>"episodes"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/episodes(.:format)                               anime#update_relationship {:relationship=>"episodes"}
#                                              DELETE    /edge/anime/:anime_id/relationships/episodes(.:format)                               anime#destroy_relationship {:relationship=>"episodes"}
#                               anime_episodes GET       /edge/anime/:anime_id/episodes(.:format)                                             episodes#get_related_resources {:relationship=>"episodes", :source=>"anime"}
#          anime_relationships_streaming_links GET       /edge/anime/:anime_id/relationships/streaming-links(.:format)                        anime#show_relationship {:relationship=>"streaming_links"}
#                                              POST      /edge/anime/:anime_id/relationships/streaming-links(.:format)                        anime#create_relationship {:relationship=>"streaming_links"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/streaming-links(.:format)                        anime#update_relationship {:relationship=>"streaming_links"}
#                                              DELETE    /edge/anime/:anime_id/relationships/streaming-links(.:format)                        anime#destroy_relationship {:relationship=>"streaming_links"}
#                        anime_streaming_links GET       /edge/anime/:anime_id/streaming-links(.:format)                                      streaming_links#get_related_resources {:relationship=>"streaming_links", :source=>"anime"}
#        anime_relationships_anime_productions GET       /edge/anime/:anime_id/relationships/anime-productions(.:format)                      anime#show_relationship {:relationship=>"anime_productions"}
#                                              POST      /edge/anime/:anime_id/relationships/anime-productions(.:format)                      anime#create_relationship {:relationship=>"anime_productions"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/anime-productions(.:format)                      anime#update_relationship {:relationship=>"anime_productions"}
#                                              DELETE    /edge/anime/:anime_id/relationships/anime-productions(.:format)                      anime#destroy_relationship {:relationship=>"anime_productions"}
#                      anime_anime_productions GET       /edge/anime/:anime_id/anime-productions(.:format)                                    anime_productions#get_related_resources {:relationship=>"anime_productions", :source=>"anime"}
#         anime_relationships_anime_characters GET       /edge/anime/:anime_id/relationships/anime-characters(.:format)                       anime#show_relationship {:relationship=>"anime_characters"}
#                                              POST      /edge/anime/:anime_id/relationships/anime-characters(.:format)                       anime#create_relationship {:relationship=>"anime_characters"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/anime-characters(.:format)                       anime#update_relationship {:relationship=>"anime_characters"}
#                                              DELETE    /edge/anime/:anime_id/relationships/anime-characters(.:format)                       anime#destroy_relationship {:relationship=>"anime_characters"}
#                       anime_anime_characters GET       /edge/anime/:anime_id/anime-characters(.:format)                                     anime_characters#get_related_resources {:relationship=>"anime_characters", :source=>"anime"}
#              anime_relationships_anime_staff GET       /edge/anime/:anime_id/relationships/anime-staff(.:format)                            anime#show_relationship {:relationship=>"anime_staff"}
#                                              POST      /edge/anime/:anime_id/relationships/anime-staff(.:format)                            anime#create_relationship {:relationship=>"anime_staff"}
#                                              PUT|PATCH /edge/anime/:anime_id/relationships/anime-staff(.:format)                            anime#update_relationship {:relationship=>"anime_staff"}
#                                              DELETE    /edge/anime/:anime_id/relationships/anime-staff(.:format)                            anime#destroy_relationship {:relationship=>"anime_staff"}
#                            anime_anime_staff GET       /edge/anime/:anime_id/anime-staff(.:format)                                          anime_staff#get_related_resources {:relationship=>"anime_staff", :source=>"anime"}
#                                  anime_index GET       /edge/anime(.:format)                                                                anime#index
#                                              POST      /edge/anime(.:format)                                                                anime#create
#                                        anime GET       /edge/anime/:id(.:format)                                                            anime#show
#                                              PATCH     /edge/anime/:id(.:format)                                                            anime#update
#                                              PUT       /edge/anime/:id(.:format)                                                            anime#update
#                                              DELETE    /edge/anime/:id(.:format)                                                            anime#destroy
#                   manga_relationships_genres GET       /edge/manga/:manga_id/relationships/genres(.:format)                                 manga#show_relationship {:relationship=>"genres"}
#                                              POST      /edge/manga/:manga_id/relationships/genres(.:format)                                 manga#create_relationship {:relationship=>"genres"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/genres(.:format)                                 manga#update_relationship {:relationship=>"genres"}
#                                              DELETE    /edge/manga/:manga_id/relationships/genres(.:format)                                 manga#destroy_relationship {:relationship=>"genres"}
#                                 manga_genres GET       /edge/manga/:manga_id/genres(.:format)                                               genres#get_related_resources {:relationship=>"genres", :source=>"manga"}
#                 manga_relationships_castings GET       /edge/manga/:manga_id/relationships/castings(.:format)                               manga#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/manga/:manga_id/relationships/castings(.:format)                               manga#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/castings(.:format)                               manga#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/manga/:manga_id/relationships/castings(.:format)                               manga#destroy_relationship {:relationship=>"castings"}
#                               manga_castings GET       /edge/manga/:manga_id/castings(.:format)                                             castings#get_related_resources {:relationship=>"castings", :source=>"manga"}
#             manga_relationships_installments GET       /edge/manga/:manga_id/relationships/installments(.:format)                           manga#show_relationship {:relationship=>"installments"}
#                                              POST      /edge/manga/:manga_id/relationships/installments(.:format)                           manga#create_relationship {:relationship=>"installments"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/installments(.:format)                           manga#update_relationship {:relationship=>"installments"}
#                                              DELETE    /edge/manga/:manga_id/relationships/installments(.:format)                           manga#destroy_relationship {:relationship=>"installments"}
#                           manga_installments GET       /edge/manga/:manga_id/installments(.:format)                                         installments#get_related_resources {:relationship=>"installments", :source=>"manga"}
#                 manga_relationships_mappings GET       /edge/manga/:manga_id/relationships/mappings(.:format)                               manga#show_relationship {:relationship=>"mappings"}
#                                              POST      /edge/manga/:manga_id/relationships/mappings(.:format)                               manga#create_relationship {:relationship=>"mappings"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/mappings(.:format)                               manga#update_relationship {:relationship=>"mappings"}
#                                              DELETE    /edge/manga/:manga_id/relationships/mappings(.:format)                               manga#destroy_relationship {:relationship=>"mappings"}
#                               manga_mappings GET       /edge/manga/:manga_id/mappings(.:format)                                             mappings#get_related_resources {:relationship=>"mappings", :source=>"manga"}
#                  manga_relationships_reviews GET       /edge/manga/:manga_id/relationships/reviews(.:format)                                manga#show_relationship {:relationship=>"reviews"}
#                                              POST      /edge/manga/:manga_id/relationships/reviews(.:format)                                manga#create_relationship {:relationship=>"reviews"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/reviews(.:format)                                manga#update_relationship {:relationship=>"reviews"}
#                                              DELETE    /edge/manga/:manga_id/relationships/reviews(.:format)                                manga#destroy_relationship {:relationship=>"reviews"}
#                                manga_reviews GET       /edge/manga/:manga_id/reviews(.:format)                                              reviews#get_related_resources {:relationship=>"reviews", :source=>"manga"}
#      manga_relationships_media_relationships GET       /edge/manga/:manga_id/relationships/media-relationships(.:format)                    manga#show_relationship {:relationship=>"media_relationships"}
#                                              POST      /edge/manga/:manga_id/relationships/media-relationships(.:format)                    manga#create_relationship {:relationship=>"media_relationships"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/media-relationships(.:format)                    manga#update_relationship {:relationship=>"media_relationships"}
#                                              DELETE    /edge/manga/:manga_id/relationships/media-relationships(.:format)                    manga#destroy_relationship {:relationship=>"media_relationships"}
#                    manga_media_relationships GET       /edge/manga/:manga_id/media-relationships(.:format)                                  media_relationships#get_related_resources {:relationship=>"media_relationships", :source=>"manga"}
#         manga_relationships_manga_characters GET       /edge/manga/:manga_id/relationships/manga-characters(.:format)                       manga#show_relationship {:relationship=>"manga_characters"}
#                                              POST      /edge/manga/:manga_id/relationships/manga-characters(.:format)                       manga#create_relationship {:relationship=>"manga_characters"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/manga-characters(.:format)                       manga#update_relationship {:relationship=>"manga_characters"}
#                                              DELETE    /edge/manga/:manga_id/relationships/manga-characters(.:format)                       manga#destroy_relationship {:relationship=>"manga_characters"}
#                       manga_manga_characters GET       /edge/manga/:manga_id/manga-characters(.:format)                                     manga_characters#get_related_resources {:relationship=>"manga_characters", :source=>"manga"}
#              manga_relationships_manga_staff GET       /edge/manga/:manga_id/relationships/manga-staff(.:format)                            manga#show_relationship {:relationship=>"manga_staff"}
#                                              POST      /edge/manga/:manga_id/relationships/manga-staff(.:format)                            manga#create_relationship {:relationship=>"manga_staff"}
#                                              PUT|PATCH /edge/manga/:manga_id/relationships/manga-staff(.:format)                            manga#update_relationship {:relationship=>"manga_staff"}
#                                              DELETE    /edge/manga/:manga_id/relationships/manga-staff(.:format)                            manga#destroy_relationship {:relationship=>"manga_staff"}
#                            manga_manga_staff GET       /edge/manga/:manga_id/manga-staff(.:format)                                          manga_staff#get_related_resources {:relationship=>"manga_staff", :source=>"manga"}
#                                  manga_index GET       /edge/manga(.:format)                                                                manga#index
#                                              POST      /edge/manga(.:format)                                                                manga#create
#                                        manga GET       /edge/manga/:id(.:format)                                                            manga#show
#                                              PATCH     /edge/manga/:id(.:format)                                                            manga#update
#                                              PUT       /edge/manga/:id(.:format)                                                            manga#update
#                                              DELETE    /edge/manga/:id(.:format)                                                            manga#destroy
#                   drama_relationships_genres GET       /edge/drama/:drama_id/relationships/genres(.:format)                                 dramas#show_relationship {:relationship=>"genres"}
#                                              POST      /edge/drama/:drama_id/relationships/genres(.:format)                                 dramas#create_relationship {:relationship=>"genres"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/genres(.:format)                                 dramas#update_relationship {:relationship=>"genres"}
#                                              DELETE    /edge/drama/:drama_id/relationships/genres(.:format)                                 dramas#destroy_relationship {:relationship=>"genres"}
#                                 drama_genres GET       /edge/drama/:drama_id/genres(.:format)                                               genres#get_related_resources {:relationship=>"genres", :source=>"dramas"}
#                 drama_relationships_castings GET       /edge/drama/:drama_id/relationships/castings(.:format)                               dramas#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/drama/:drama_id/relationships/castings(.:format)                               dramas#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/castings(.:format)                               dramas#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/drama/:drama_id/relationships/castings(.:format)                               dramas#destroy_relationship {:relationship=>"castings"}
#                               drama_castings GET       /edge/drama/:drama_id/castings(.:format)                                             castings#get_related_resources {:relationship=>"castings", :source=>"dramas"}
#             drama_relationships_installments GET       /edge/drama/:drama_id/relationships/installments(.:format)                           dramas#show_relationship {:relationship=>"installments"}
#                                              POST      /edge/drama/:drama_id/relationships/installments(.:format)                           dramas#create_relationship {:relationship=>"installments"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/installments(.:format)                           dramas#update_relationship {:relationship=>"installments"}
#                                              DELETE    /edge/drama/:drama_id/relationships/installments(.:format)                           dramas#destroy_relationship {:relationship=>"installments"}
#                           drama_installments GET       /edge/drama/:drama_id/installments(.:format)                                         installments#get_related_resources {:relationship=>"installments", :source=>"dramas"}
#                 drama_relationships_mappings GET       /edge/drama/:drama_id/relationships/mappings(.:format)                               dramas#show_relationship {:relationship=>"mappings"}
#                                              POST      /edge/drama/:drama_id/relationships/mappings(.:format)                               dramas#create_relationship {:relationship=>"mappings"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/mappings(.:format)                               dramas#update_relationship {:relationship=>"mappings"}
#                                              DELETE    /edge/drama/:drama_id/relationships/mappings(.:format)                               dramas#destroy_relationship {:relationship=>"mappings"}
#                               drama_mappings GET       /edge/drama/:drama_id/mappings(.:format)                                             mappings#get_related_resources {:relationship=>"mappings", :source=>"dramas"}
#                  drama_relationships_reviews GET       /edge/drama/:drama_id/relationships/reviews(.:format)                                dramas#show_relationship {:relationship=>"reviews"}
#                                              POST      /edge/drama/:drama_id/relationships/reviews(.:format)                                dramas#create_relationship {:relationship=>"reviews"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/reviews(.:format)                                dramas#update_relationship {:relationship=>"reviews"}
#                                              DELETE    /edge/drama/:drama_id/relationships/reviews(.:format)                                dramas#destroy_relationship {:relationship=>"reviews"}
#                                drama_reviews GET       /edge/drama/:drama_id/reviews(.:format)                                              reviews#get_related_resources {:relationship=>"reviews", :source=>"dramas"}
#      drama_relationships_media_relationships GET       /edge/drama/:drama_id/relationships/media-relationships(.:format)                    dramas#show_relationship {:relationship=>"media_relationships"}
#                                              POST      /edge/drama/:drama_id/relationships/media-relationships(.:format)                    dramas#create_relationship {:relationship=>"media_relationships"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/media-relationships(.:format)                    dramas#update_relationship {:relationship=>"media_relationships"}
#                                              DELETE    /edge/drama/:drama_id/relationships/media-relationships(.:format)                    dramas#destroy_relationship {:relationship=>"media_relationships"}
#                    drama_media_relationships GET       /edge/drama/:drama_id/media-relationships(.:format)                                  media_relationships#get_related_resources {:relationship=>"media_relationships", :source=>"dramas"}
#                 drama_relationships_episodes GET       /edge/drama/:drama_id/relationships/episodes(.:format)                               dramas#show_relationship {:relationship=>"episodes"}
#                                              POST      /edge/drama/:drama_id/relationships/episodes(.:format)                               dramas#create_relationship {:relationship=>"episodes"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/episodes(.:format)                               dramas#update_relationship {:relationship=>"episodes"}
#                                              DELETE    /edge/drama/:drama_id/relationships/episodes(.:format)                               dramas#destroy_relationship {:relationship=>"episodes"}
#                               drama_episodes GET       /edge/drama/:drama_id/episodes(.:format)                                             episodes#get_related_resources {:relationship=>"episodes", :source=>"dramas"}
#         drama_relationships_drama_characters GET       /edge/drama/:drama_id/relationships/drama-characters(.:format)                       dramas#show_relationship {:relationship=>"drama_characters"}
#                                              POST      /edge/drama/:drama_id/relationships/drama-characters(.:format)                       dramas#create_relationship {:relationship=>"drama_characters"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/drama-characters(.:format)                       dramas#update_relationship {:relationship=>"drama_characters"}
#                                              DELETE    /edge/drama/:drama_id/relationships/drama-characters(.:format)                       dramas#destroy_relationship {:relationship=>"drama_characters"}
#                       drama_drama_characters GET       /edge/drama/:drama_id/drama-characters(.:format)                                     drama_characters#get_related_resources {:relationship=>"drama_characters", :source=>"dramas"}
#              drama_relationships_drama_staff GET       /edge/drama/:drama_id/relationships/drama-staff(.:format)                            dramas#show_relationship {:relationship=>"drama_staff"}
#                                              POST      /edge/drama/:drama_id/relationships/drama-staff(.:format)                            dramas#create_relationship {:relationship=>"drama_staff"}
#                                              PUT|PATCH /edge/drama/:drama_id/relationships/drama-staff(.:format)                            dramas#update_relationship {:relationship=>"drama_staff"}
#                                              DELETE    /edge/drama/:drama_id/relationships/drama-staff(.:format)                            dramas#destroy_relationship {:relationship=>"drama_staff"}
#                            drama_drama_staff GET       /edge/drama/:drama_id/drama-staff(.:format)                                          drama_staff#get_related_resources {:relationship=>"drama_staff", :source=>"dramas"}
#                                  drama_index GET       /edge/drama(.:format)                                                                drama#index
#                                              POST      /edge/drama(.:format)                                                                drama#create
#                                        drama GET       /edge/drama/:id(.:format)                                                            drama#show
#                                              PATCH     /edge/drama/:id(.:format)                                                            drama#update
#                                              PUT       /edge/drama/:id(.:format)                                                            drama#update
#                                              DELETE    /edge/drama/:id(.:format)                                                            drama#destroy
#                     user_relationships_waifu GET       /edge/users/:user_id/relationships/waifu(.:format)                                   users#show_relationship {:relationship=>"waifu"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/waifu(.:format)                                   users#update_relationship {:relationship=>"waifu"}
#                                              DELETE    /edge/users/:user_id/relationships/waifu(.:format)                                   users#destroy_relationship {:relationship=>"waifu"}
#                                   user_waifu GET       /edge/users/:user_id/waifu(.:format)                                                 characters#get_related_resource {:relationship=>"waifu", :source=>"users"}
#               user_relationships_pinned_post GET       /edge/users/:user_id/relationships/pinned-post(.:format)                             users#show_relationship {:relationship=>"pinned_post"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/pinned-post(.:format)                             users#update_relationship {:relationship=>"pinned_post"}
#                                              DELETE    /edge/users/:user_id/relationships/pinned-post(.:format)                             users#destroy_relationship {:relationship=>"pinned_post"}
#                             user_pinned_post GET       /edge/users/:user_id/pinned-post(.:format)                                           posts#get_related_resource {:relationship=>"pinned_post", :source=>"users"}
#                 user_relationships_followers GET       /edge/users/:user_id/relationships/followers(.:format)                               users#show_relationship {:relationship=>"followers"}
#                                              POST      /edge/users/:user_id/relationships/followers(.:format)                               users#create_relationship {:relationship=>"followers"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/followers(.:format)                               users#update_relationship {:relationship=>"followers"}
#                                              DELETE    /edge/users/:user_id/relationships/followers(.:format)                               users#destroy_relationship {:relationship=>"followers"}
#                               user_followers GET       /edge/users/:user_id/followers(.:format)                                             follows#get_related_resources {:relationship=>"followers", :source=>"users"}
#                 user_relationships_following GET       /edge/users/:user_id/relationships/following(.:format)                               users#show_relationship {:relationship=>"following"}
#                                              POST      /edge/users/:user_id/relationships/following(.:format)                               users#create_relationship {:relationship=>"following"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/following(.:format)                               users#update_relationship {:relationship=>"following"}
#                                              DELETE    /edge/users/:user_id/relationships/following(.:format)                               users#destroy_relationship {:relationship=>"following"}
#                               user_following GET       /edge/users/:user_id/following(.:format)                                             follows#get_related_resources {:relationship=>"following", :source=>"users"}
#                    user_relationships_blocks GET       /edge/users/:user_id/relationships/blocks(.:format)                                  users#show_relationship {:relationship=>"blocks"}
#                                              POST      /edge/users/:user_id/relationships/blocks(.:format)                                  users#create_relationship {:relationship=>"blocks"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/blocks(.:format)                                  users#update_relationship {:relationship=>"blocks"}
#                                              DELETE    /edge/users/:user_id/relationships/blocks(.:format)                                  users#destroy_relationship {:relationship=>"blocks"}
#                                  user_blocks GET       /edge/users/:user_id/blocks(.:format)                                                blocks#get_related_resources {:relationship=>"blocks", :source=>"users"}
#           user_relationships_linked_accounts GET       /edge/users/:user_id/relationships/linked-accounts(.:format)                         users#show_relationship {:relationship=>"linked_accounts"}
#                                              POST      /edge/users/:user_id/relationships/linked-accounts(.:format)                         users#create_relationship {:relationship=>"linked_accounts"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/linked-accounts(.:format)                         users#update_relationship {:relationship=>"linked_accounts"}
#                                              DELETE    /edge/users/:user_id/relationships/linked-accounts(.:format)                         users#destroy_relationship {:relationship=>"linked_accounts"}
#                         user_linked_accounts GET       /edge/users/:user_id/linked-accounts(.:format)                                       linked_accounts#get_related_resources {:relationship=>"linked_accounts", :source=>"users"}
#             user_relationships_profile_links GET       /edge/users/:user_id/relationships/profile-links(.:format)                           users#show_relationship {:relationship=>"profile_links"}
#                                              POST      /edge/users/:user_id/relationships/profile-links(.:format)                           users#create_relationship {:relationship=>"profile_links"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/profile-links(.:format)                           users#update_relationship {:relationship=>"profile_links"}
#                                              DELETE    /edge/users/:user_id/relationships/profile-links(.:format)                           users#destroy_relationship {:relationship=>"profile_links"}
#                           user_profile_links GET       /edge/users/:user_id/profile-links(.:format)                                         profile_links#get_related_resources {:relationship=>"profile_links", :source=>"users"}
#             user_relationships_media_follows GET       /edge/users/:user_id/relationships/media-follows(.:format)                           users#show_relationship {:relationship=>"media_follows"}
#                                              POST      /edge/users/:user_id/relationships/media-follows(.:format)                           users#create_relationship {:relationship=>"media_follows"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/media-follows(.:format)                           users#update_relationship {:relationship=>"media_follows"}
#                                              DELETE    /edge/users/:user_id/relationships/media-follows(.:format)                           users#destroy_relationship {:relationship=>"media_follows"}
#                           user_media_follows GET       /edge/users/:user_id/media-follows(.:format)                                         media_follows#get_related_resources {:relationship=>"media_follows", :source=>"users"}
#                user_relationships_user_roles GET       /edge/users/:user_id/relationships/user-roles(.:format)                              users#show_relationship {:relationship=>"user_roles"}
#                                              POST      /edge/users/:user_id/relationships/user-roles(.:format)                              users#create_relationship {:relationship=>"user_roles"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/user-roles(.:format)                              users#update_relationship {:relationship=>"user_roles"}
#                                              DELETE    /edge/users/:user_id/relationships/user-roles(.:format)                              users#destroy_relationship {:relationship=>"user_roles"}
#                              user_user_roles GET       /edge/users/:user_id/user-roles(.:format)                                            user_roles#get_related_resources {:relationship=>"user_roles", :source=>"users"}
#           user_relationships_library_entries GET       /edge/users/:user_id/relationships/library-entries(.:format)                         users#show_relationship {:relationship=>"library_entries"}
#                                              POST      /edge/users/:user_id/relationships/library-entries(.:format)                         users#create_relationship {:relationship=>"library_entries"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/library-entries(.:format)                         users#update_relationship {:relationship=>"library_entries"}
#                                              DELETE    /edge/users/:user_id/relationships/library-entries(.:format)                         users#destroy_relationship {:relationship=>"library_entries"}
#                         user_library_entries GET       /edge/users/:user_id/library-entries(.:format)                                       library_entries#get_related_resources {:relationship=>"library_entries", :source=>"users"}
#                 user_relationships_favorites GET       /edge/users/:user_id/relationships/favorites(.:format)                               users#show_relationship {:relationship=>"favorites"}
#                                              POST      /edge/users/:user_id/relationships/favorites(.:format)                               users#create_relationship {:relationship=>"favorites"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/favorites(.:format)                               users#update_relationship {:relationship=>"favorites"}
#                                              DELETE    /edge/users/:user_id/relationships/favorites(.:format)                               users#destroy_relationship {:relationship=>"favorites"}
#                               user_favorites GET       /edge/users/:user_id/favorites(.:format)                                             favorites#get_related_resources {:relationship=>"favorites", :source=>"users"}
#                   user_relationships_reviews GET       /edge/users/:user_id/relationships/reviews(.:format)                                 users#show_relationship {:relationship=>"reviews"}
#                                              POST      /edge/users/:user_id/relationships/reviews(.:format)                                 users#create_relationship {:relationship=>"reviews"}
#                                              PUT|PATCH /edge/users/:user_id/relationships/reviews(.:format)                                 users#update_relationship {:relationship=>"reviews"}
#                                              DELETE    /edge/users/:user_id/relationships/reviews(.:format)                                 users#destroy_relationship {:relationship=>"reviews"}
#                                 user_reviews GET       /edge/users/:user_id/reviews(.:format)                                               reviews#get_related_resources {:relationship=>"reviews", :source=>"users"}
#                                        users GET       /edge/users(.:format)                                                                users#index
#                                              POST      /edge/users(.:format)                                                                users#create
#                                         user GET       /edge/users/:id(.:format)                                                            users#show
#                                              PATCH     /edge/users/:id(.:format)                                                            users#update
#                                              PUT       /edge/users/:id(.:format)                                                            users#update
#                                              DELETE    /edge/users/:id(.:format)                                                            users#destroy
#                 import_from_facebook_follows POST      /edge/follows/import_from_facebook(.:format)                                         follows#import_from_facebook
#                  import_from_twitter_follows POST      /edge/follows/import_from_twitter(.:format)                                          follows#import_from_twitter
#                                      follows GET       /edge/follows(.:format)                                                              follows#index
#                                              POST      /edge/follows(.:format)                                                              follows#create
#                                       follow GET       /edge/follows/:id(.:format)                                                          follows#show
#                                              PATCH     /edge/follows/:id(.:format)                                                          follows#update
#                                              PUT       /edge/follows/:id(.:format)                                                          follows#update
#                                              DELETE    /edge/follows/:id(.:format)                                                          follows#destroy
#              media_follow_relationships_user GET       /edge/media-follows/:media_follow_id/relationships/user(.:format)                    media_follows#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/media-follows/:media_follow_id/relationships/user(.:format)                    media_follows#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/media-follows/:media_follow_id/relationships/user(.:format)                    media_follows#destroy_relationship {:relationship=>"user"}
#                            media_follow_user GET       /edge/media-follows/:media_follow_id/user(.:format)                                  users#get_related_resource {:relationship=>"user", :source=>"media_follows"}
#             media_follow_relationships_media GET       /edge/media-follows/:media_follow_id/relationships/media(.:format)                   media_follows#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/media-follows/:media_follow_id/relationships/media(.:format)                   media_follows#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/media-follows/:media_follow_id/relationships/media(.:format)                   media_follows#destroy_relationship {:relationship=>"media"}
#                           media_follow_media GET       /edge/media-follows/:media_follow_id/media(.:format)                                 media#get_related_resource {:relationship=>"media", :source=>"media_follows"}
#                                media_follows GET       /edge/media-follows(.:format)                                                        media_follows#index
#                                              POST      /edge/media-follows(.:format)                                                        media_follows#create
#                                 media_follow GET       /edge/media-follows/:id(.:format)                                                    media_follows#show
#                                              PATCH     /edge/media-follows/:id(.:format)                                                    media_follows#update
#                                              PUT       /edge/media-follows/:id(.:format)                                                    media_follows#update
#                                              DELETE    /edge/media-follows/:id(.:format)                                                    media_follows#destroy
#        character_relationships_primary_media GET       /edge/characters/:character_id/relationships/primary-media(.:format)                 characters#show_relationship {:relationship=>"primary_media"}
#                                              PUT|PATCH /edge/characters/:character_id/relationships/primary-media(.:format)                 characters#update_relationship {:relationship=>"primary_media"}
#                                              DELETE    /edge/characters/:character_id/relationships/primary-media(.:format)                 characters#destroy_relationship {:relationship=>"primary_media"}
#                      character_primary_media GET       /edge/characters/:character_id/primary-media(.:format)                               primary_media#get_related_resource {:relationship=>"primary_media", :source=>"characters"}
#             character_relationships_castings GET       /edge/characters/:character_id/relationships/castings(.:format)                      characters#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/characters/:character_id/relationships/castings(.:format)                      characters#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/characters/:character_id/relationships/castings(.:format)                      characters#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/characters/:character_id/relationships/castings(.:format)                      characters#destroy_relationship {:relationship=>"castings"}
#                           character_castings GET       /edge/characters/:character_id/castings(.:format)                                    castings#get_related_resources {:relationship=>"castings", :source=>"characters"}
#                                   characters GET       /edge/characters(.:format)                                                           characters#index
#                                              POST      /edge/characters(.:format)                                                           characters#create
#                                    character GET       /edge/characters/:id(.:format)                                                       characters#show
#                                              PATCH     /edge/characters/:id(.:format)                                                       characters#update
#                                              PUT       /edge/characters/:id(.:format)                                                       characters#update
#                                              DELETE    /edge/characters/:id(.:format)                                                       characters#destroy
#                person_relationships_castings GET       /edge/people/:person_id/relationships/castings(.:format)                             people#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/people/:person_id/relationships/castings(.:format)                             people#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/people/:person_id/relationships/castings(.:format)                             people#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/people/:person_id/relationships/castings(.:format)                             people#destroy_relationship {:relationship=>"castings"}
#                              person_castings GET       /edge/people/:person_id/castings(.:format)                                           castings#get_related_resources {:relationship=>"castings", :source=>"people"}
#                                       people GET       /edge/people(.:format)                                                               people#index
#                                              POST      /edge/people(.:format)                                                               people#create
#                                       person GET       /edge/people/:id(.:format)                                                           people#show
#                                              PATCH     /edge/people/:id(.:format)                                                           people#update
#                                              PUT       /edge/people/:id(.:format)                                                           people#update
#                                              DELETE    /edge/people/:id(.:format)                                                           people#destroy
#                  casting_relationships_media GET       /edge/castings/:casting_id/relationships/media(.:format)                             castings#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/castings/:casting_id/relationships/media(.:format)                             castings#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/castings/:casting_id/relationships/media(.:format)                             castings#destroy_relationship {:relationship=>"media"}
#                                casting_media GET       /edge/castings/:casting_id/media(.:format)                                           media#get_related_resource {:relationship=>"media", :source=>"castings"}
#              casting_relationships_character GET       /edge/castings/:casting_id/relationships/character(.:format)                         castings#show_relationship {:relationship=>"character"}
#                                              PUT|PATCH /edge/castings/:casting_id/relationships/character(.:format)                         castings#update_relationship {:relationship=>"character"}
#                                              DELETE    /edge/castings/:casting_id/relationships/character(.:format)                         castings#destroy_relationship {:relationship=>"character"}
#                            casting_character GET       /edge/castings/:casting_id/character(.:format)                                       characters#get_related_resource {:relationship=>"character", :source=>"castings"}
#                 casting_relationships_person GET       /edge/castings/:casting_id/relationships/person(.:format)                            castings#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/castings/:casting_id/relationships/person(.:format)                            castings#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/castings/:casting_id/relationships/person(.:format)                            castings#destroy_relationship {:relationship=>"person"}
#                               casting_person GET       /edge/castings/:casting_id/person(.:format)                                          people#get_related_resource {:relationship=>"person", :source=>"castings"}
#                                     castings GET       /edge/castings(.:format)                                                             castings#index
#                                              POST      /edge/castings(.:format)                                                             castings#create
#                                      casting GET       /edge/castings/:id(.:format)                                                         castings#show
#                                              PATCH     /edge/castings/:id(.:format)                                                         castings#update
#                                              PUT       /edge/castings/:id(.:format)                                                         castings#update
#                                              DELETE    /edge/castings/:id(.:format)                                                         castings#destroy
#                                       genres GET       /edge/genres(.:format)                                                               genres#index
#                                              POST      /edge/genres(.:format)                                                               genres#create
#                                        genre GET       /edge/genres/:id(.:format)                                                           genres#show
#                                              PATCH     /edge/genres/:id(.:format)                                                           genres#update
#                                              PUT       /edge/genres/:id(.:format)                                                           genres#update
#                                              DELETE    /edge/genres/:id(.:format)                                                           genres#destroy
#       streamer_relationships_streaming_links GET       /edge/streamers/:streamer_id/relationships/streaming-links(.:format)                 streamers#show_relationship {:relationship=>"streaming_links"}
#                                              POST      /edge/streamers/:streamer_id/relationships/streaming-links(.:format)                 streamers#create_relationship {:relationship=>"streaming_links"}
#                                              PUT|PATCH /edge/streamers/:streamer_id/relationships/streaming-links(.:format)                 streamers#update_relationship {:relationship=>"streaming_links"}
#                                              DELETE    /edge/streamers/:streamer_id/relationships/streaming-links(.:format)                 streamers#destroy_relationship {:relationship=>"streaming_links"}
#                     streamer_streaming_links GET       /edge/streamers/:streamer_id/streaming-links(.:format)                               streaming_links#get_related_resources {:relationship=>"streaming_links", :source=>"streamers"}
#                                    streamers GET       /edge/streamers(.:format)                                                            streamers#index
#                                              POST      /edge/streamers(.:format)                                                            streamers#create
#                                     streamer GET       /edge/streamers/:id(.:format)                                                        streamers#show
#                                              PATCH     /edge/streamers/:id(.:format)                                                        streamers#update
#                                              PUT       /edge/streamers/:id(.:format)                                                        streamers#update
#                                              DELETE    /edge/streamers/:id(.:format)                                                        streamers#destroy
#        streaming_link_relationships_streamer GET       /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format)            streaming_links#show_relationship {:relationship=>"streamer"}
#                                              PUT|PATCH /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format)            streaming_links#update_relationship {:relationship=>"streamer"}
#                                              DELETE    /edge/streaming-links/:streaming_link_id/relationships/streamer(.:format)            streaming_links#destroy_relationship {:relationship=>"streamer"}
#                      streaming_link_streamer GET       /edge/streaming-links/:streaming_link_id/streamer(.:format)                          streamers#get_related_resource {:relationship=>"streamer", :source=>"streaming_links"}
#           streaming_link_relationships_media GET       /edge/streaming-links/:streaming_link_id/relationships/media(.:format)               streaming_links#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/streaming-links/:streaming_link_id/relationships/media(.:format)               streaming_links#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/streaming-links/:streaming_link_id/relationships/media(.:format)               streaming_links#destroy_relationship {:relationship=>"media"}
#                         streaming_link_media GET       /edge/streaming-links/:streaming_link_id/media(.:format)                             media#get_related_resource {:relationship=>"media", :source=>"streaming_links"}
#                              streaming_links GET       /edge/streaming-links(.:format)                                                      streaming_links#index
#                                              POST      /edge/streaming-links(.:format)                                                      streaming_links#create
#                               streaming_link GET       /edge/streaming-links/:id(.:format)                                                  streaming_links#show
#                                              PATCH     /edge/streaming-links/:id(.:format)                                                  streaming_links#update
#                                              PUT       /edge/streaming-links/:id(.:format)                                                  streaming_links#update
#                                              DELETE    /edge/streaming-links/:id(.:format)                                                  streaming_links#destroy
#         franchise_relationships_installments GET       /edge/franchises/:franchise_id/relationships/installments(.:format)                  franchises#show_relationship {:relationship=>"installments"}
#                                              POST      /edge/franchises/:franchise_id/relationships/installments(.:format)                  franchises#create_relationship {:relationship=>"installments"}
#                                              PUT|PATCH /edge/franchises/:franchise_id/relationships/installments(.:format)                  franchises#update_relationship {:relationship=>"installments"}
#                                              DELETE    /edge/franchises/:franchise_id/relationships/installments(.:format)                  franchises#destroy_relationship {:relationship=>"installments"}
#                       franchise_installments GET       /edge/franchises/:franchise_id/installments(.:format)                                installments#get_related_resources {:relationship=>"installments", :source=>"franchises"}
#                                   franchises GET       /edge/franchises(.:format)                                                           franchises#index
#                                              POST      /edge/franchises(.:format)                                                           franchises#create
#                                    franchise GET       /edge/franchises/:id(.:format)                                                       franchises#show
#                                              PATCH     /edge/franchises/:id(.:format)                                                       franchises#update
#                                              PUT       /edge/franchises/:id(.:format)                                                       franchises#update
#                                              DELETE    /edge/franchises/:id(.:format)                                                       franchises#destroy
#          installment_relationships_franchise GET       /edge/installments/:installment_id/relationships/franchise(.:format)                 installments#show_relationship {:relationship=>"franchise"}
#                                              PUT|PATCH /edge/installments/:installment_id/relationships/franchise(.:format)                 installments#update_relationship {:relationship=>"franchise"}
#                                              DELETE    /edge/installments/:installment_id/relationships/franchise(.:format)                 installments#destroy_relationship {:relationship=>"franchise"}
#                        installment_franchise GET       /edge/installments/:installment_id/franchise(.:format)                               franchises#get_related_resource {:relationship=>"franchise", :source=>"installments"}
#              installment_relationships_media GET       /edge/installments/:installment_id/relationships/media(.:format)                     installments#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/installments/:installment_id/relationships/media(.:format)                     installments#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/installments/:installment_id/relationships/media(.:format)                     installments#destroy_relationship {:relationship=>"media"}
#                            installment_media GET       /edge/installments/:installment_id/media(.:format)                                   media#get_related_resource {:relationship=>"media", :source=>"installments"}
#                                 installments GET       /edge/installments(.:format)                                                         installments#index
#                                              POST      /edge/installments(.:format)                                                         installments#create
#                                  installment GET       /edge/installments/:id(.:format)                                                     installments#show
#                                              PATCH     /edge/installments/:id(.:format)                                                     installments#update
#                                              PUT       /edge/installments/:id(.:format)                                                     installments#update
#                                              DELETE    /edge/installments/:id(.:format)                                                     installments#destroy
#                  mapping_relationships_media GET       /edge/mappings/:mapping_id/relationships/media(.:format)                             mappings#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/mappings/:mapping_id/relationships/media(.:format)                             mappings#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/mappings/:mapping_id/relationships/media(.:format)                             mappings#destroy_relationship {:relationship=>"media"}
#                                mapping_media GET       /edge/mappings/:mapping_id/media(.:format)                                           media#get_related_resource {:relationship=>"media", :source=>"mappings"}
#                                     mappings GET       /edge/mappings(.:format)                                                             mappings#index
#                                              POST      /edge/mappings(.:format)                                                             mappings#create
#                                      mapping GET       /edge/mappings/:id(.:format)                                                         mappings#show
#                                              PATCH     /edge/mappings/:id(.:format)                                                         mappings#update
#                                              PUT       /edge/mappings/:id(.:format)                                                         mappings#update
#                                              DELETE    /edge/mappings/:id(.:format)                                                         mappings#destroy
#                      post_relationships_user GET       /edge/posts/:post_id/relationships/user(.:format)                                    posts#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/user(.:format)                                    posts#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/posts/:post_id/relationships/user(.:format)                                    posts#destroy_relationship {:relationship=>"user"}
#                                    post_user GET       /edge/posts/:post_id/user(.:format)                                                  users#get_related_resource {:relationship=>"user", :source=>"posts"}
#               post_relationships_target_user GET       /edge/posts/:post_id/relationships/target-user(.:format)                             posts#show_relationship {:relationship=>"target_user"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/target-user(.:format)                             posts#update_relationship {:relationship=>"target_user"}
#                                              DELETE    /edge/posts/:post_id/relationships/target-user(.:format)                             posts#destroy_relationship {:relationship=>"target_user"}
#                             post_target_user GET       /edge/posts/:post_id/target-user(.:format)                                           users#get_related_resource {:relationship=>"target_user", :source=>"posts"}
#                     post_relationships_media GET       /edge/posts/:post_id/relationships/media(.:format)                                   posts#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/media(.:format)                                   posts#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/posts/:post_id/relationships/media(.:format)                                   posts#destroy_relationship {:relationship=>"media"}
#                                   post_media GET       /edge/posts/:post_id/media(.:format)                                                 media#get_related_resource {:relationship=>"media", :source=>"posts"}
#              post_relationships_spoiled_unit GET       /edge/posts/:post_id/relationships/spoiled-unit(.:format)                            posts#show_relationship {:relationship=>"spoiled_unit"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/spoiled-unit(.:format)                            posts#update_relationship {:relationship=>"spoiled_unit"}
#                                              DELETE    /edge/posts/:post_id/relationships/spoiled-unit(.:format)                            posts#destroy_relationship {:relationship=>"spoiled_unit"}
#                            post_spoiled_unit GET       /edge/posts/:post_id/spoiled-unit(.:format)                                          spoiled_units#get_related_resource {:relationship=>"spoiled_unit", :source=>"posts"}
#                post_relationships_post_likes GET       /edge/posts/:post_id/relationships/post-likes(.:format)                              posts#show_relationship {:relationship=>"post_likes"}
#                                              POST      /edge/posts/:post_id/relationships/post-likes(.:format)                              posts#create_relationship {:relationship=>"post_likes"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/post-likes(.:format)                              posts#update_relationship {:relationship=>"post_likes"}
#                                              DELETE    /edge/posts/:post_id/relationships/post-likes(.:format)                              posts#destroy_relationship {:relationship=>"post_likes"}
#                              post_post_likes GET       /edge/posts/:post_id/post-likes(.:format)                                            post_likes#get_related_resources {:relationship=>"post_likes", :source=>"posts"}
#                  post_relationships_comments GET       /edge/posts/:post_id/relationships/comments(.:format)                                posts#show_relationship {:relationship=>"comments"}
#                                              POST      /edge/posts/:post_id/relationships/comments(.:format)                                posts#create_relationship {:relationship=>"comments"}
#                                              PUT|PATCH /edge/posts/:post_id/relationships/comments(.:format)                                posts#update_relationship {:relationship=>"comments"}
#                                              DELETE    /edge/posts/:post_id/relationships/comments(.:format)                                posts#destroy_relationship {:relationship=>"comments"}
#                                post_comments GET       /edge/posts/:post_id/comments(.:format)                                              comments#get_related_resources {:relationship=>"comments", :source=>"posts"}
#                                        posts GET       /edge/posts(.:format)                                                                posts#index
#                                              POST      /edge/posts(.:format)                                                                posts#create
#                                         post GET       /edge/posts/:id(.:format)                                                            posts#show
#                                              PATCH     /edge/posts/:id(.:format)                                                            posts#update
#                                              PUT       /edge/posts/:id(.:format)                                                            posts#update
#                                              DELETE    /edge/posts/:id(.:format)                                                            posts#destroy
#                   comment_relationships_user GET       /edge/comments/:comment_id/relationships/user(.:format)                              comments#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/comments/:comment_id/relationships/user(.:format)                              comments#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/comments/:comment_id/relationships/user(.:format)                              comments#destroy_relationship {:relationship=>"user"}
#                                 comment_user GET       /edge/comments/:comment_id/user(.:format)                                            users#get_related_resource {:relationship=>"user", :source=>"comments"}
#                   comment_relationships_post GET       /edge/comments/:comment_id/relationships/post(.:format)                              comments#show_relationship {:relationship=>"post"}
#                                              PUT|PATCH /edge/comments/:comment_id/relationships/post(.:format)                              comments#update_relationship {:relationship=>"post"}
#                                              DELETE    /edge/comments/:comment_id/relationships/post(.:format)                              comments#destroy_relationship {:relationship=>"post"}
#                                 comment_post GET       /edge/comments/:comment_id/post(.:format)                                            posts#get_related_resource {:relationship=>"post", :source=>"comments"}
#                 comment_relationships_parent GET       /edge/comments/:comment_id/relationships/parent(.:format)                            comments#show_relationship {:relationship=>"parent"}
#                                              PUT|PATCH /edge/comments/:comment_id/relationships/parent(.:format)                            comments#update_relationship {:relationship=>"parent"}
#                                              DELETE    /edge/comments/:comment_id/relationships/parent(.:format)                            comments#destroy_relationship {:relationship=>"parent"}
#                               comment_parent GET       /edge/comments/:comment_id/parent(.:format)                                          comments#get_related_resource {:relationship=>"parent", :source=>"comments"}
#                  comment_relationships_likes GET       /edge/comments/:comment_id/relationships/likes(.:format)                             comments#show_relationship {:relationship=>"likes"}
#                                              POST      /edge/comments/:comment_id/relationships/likes(.:format)                             comments#create_relationship {:relationship=>"likes"}
#                                              PUT|PATCH /edge/comments/:comment_id/relationships/likes(.:format)                             comments#update_relationship {:relationship=>"likes"}
#                                              DELETE    /edge/comments/:comment_id/relationships/likes(.:format)                             comments#destroy_relationship {:relationship=>"likes"}
#                                comment_likes GET       /edge/comments/:comment_id/likes(.:format)                                           comment_likes#get_related_resources {:relationship=>"likes", :source=>"comments"}
#                comment_relationships_replies GET       /edge/comments/:comment_id/relationships/replies(.:format)                           comments#show_relationship {:relationship=>"replies"}
#                                              POST      /edge/comments/:comment_id/relationships/replies(.:format)                           comments#create_relationship {:relationship=>"replies"}
#                                              PUT|PATCH /edge/comments/:comment_id/relationships/replies(.:format)                           comments#update_relationship {:relationship=>"replies"}
#                                              DELETE    /edge/comments/:comment_id/relationships/replies(.:format)                           comments#destroy_relationship {:relationship=>"replies"}
#                              comment_replies GET       /edge/comments/:comment_id/replies(.:format)                                         comments#get_related_resources {:relationship=>"replies", :source=>"comments"}
#                                     comments GET       /edge/comments(.:format)                                                             comments#index
#                                              POST      /edge/comments(.:format)                                                             comments#create
#                                      comment GET       /edge/comments/:id(.:format)                                                         comments#show
#                                              PATCH     /edge/comments/:id(.:format)                                                         comments#update
#                                              PUT       /edge/comments/:id(.:format)                                                         comments#update
#                                              DELETE    /edge/comments/:id(.:format)                                                         comments#destroy
#                 post_like_relationships_post GET       /edge/post-likes/:post_like_id/relationships/post(.:format)                          post_likes#show_relationship {:relationship=>"post"}
#                                              PUT|PATCH /edge/post-likes/:post_like_id/relationships/post(.:format)                          post_likes#update_relationship {:relationship=>"post"}
#                                              DELETE    /edge/post-likes/:post_like_id/relationships/post(.:format)                          post_likes#destroy_relationship {:relationship=>"post"}
#                               post_like_post GET       /edge/post-likes/:post_like_id/post(.:format)                                        posts#get_related_resource {:relationship=>"post", :source=>"post_likes"}
#                 post_like_relationships_user GET       /edge/post-likes/:post_like_id/relationships/user(.:format)                          post_likes#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/post-likes/:post_like_id/relationships/user(.:format)                          post_likes#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/post-likes/:post_like_id/relationships/user(.:format)                          post_likes#destroy_relationship {:relationship=>"user"}
#                               post_like_user GET       /edge/post-likes/:post_like_id/user(.:format)                                        users#get_related_resource {:relationship=>"user", :source=>"post_likes"}
#                                   post_likes GET       /edge/post-likes(.:format)                                                           post_likes#index
#                                              POST      /edge/post-likes(.:format)                                                           post_likes#create
#                                    post_like GET       /edge/post-likes/:id(.:format)                                                       post_likes#show
#                                              PATCH     /edge/post-likes/:id(.:format)                                                       post_likes#update
#                                              PUT       /edge/post-likes/:id(.:format)                                                       post_likes#update
#                                              DELETE    /edge/post-likes/:id(.:format)                                                       post_likes#destroy
#           comment_like_relationships_comment GET       /edge/comment-likes/:comment_like_id/relationships/comment(.:format)                 comment_likes#show_relationship {:relationship=>"comment"}
#                                              PUT|PATCH /edge/comment-likes/:comment_like_id/relationships/comment(.:format)                 comment_likes#update_relationship {:relationship=>"comment"}
#                                              DELETE    /edge/comment-likes/:comment_like_id/relationships/comment(.:format)                 comment_likes#destroy_relationship {:relationship=>"comment"}
#                         comment_like_comment GET       /edge/comment-likes/:comment_like_id/comment(.:format)                               comments#get_related_resource {:relationship=>"comment", :source=>"comment_likes"}
#              comment_like_relationships_user GET       /edge/comment-likes/:comment_like_id/relationships/user(.:format)                    comment_likes#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/comment-likes/:comment_like_id/relationships/user(.:format)                    comment_likes#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/comment-likes/:comment_like_id/relationships/user(.:format)                    comment_likes#destroy_relationship {:relationship=>"user"}
#                            comment_like_user GET       /edge/comment-likes/:comment_like_id/user(.:format)                                  users#get_related_resource {:relationship=>"user", :source=>"comment_likes"}
#                                              GET       /edge/comment-likes(.:format)                                                        comment_likes#index
#                                              POST      /edge/comment-likes(.:format)                                                        comment_likes#create
#                                 comment_like GET       /edge/comment-likes/:id(.:format)                                                    comment_likes#show
#                                              PATCH     /edge/comment-likes/:id(.:format)                                                    comment_likes#update
#                                              PUT       /edge/comment-likes/:id(.:format)                                                    comment_likes#update
#                                              DELETE    /edge/comment-likes/:id(.:format)                                                    comment_likes#destroy
#                     block_relationships_user GET       /edge/blocks/:block_id/relationships/user(.:format)                                  blocks#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/blocks/:block_id/relationships/user(.:format)                                  blocks#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/blocks/:block_id/relationships/user(.:format)                                  blocks#destroy_relationship {:relationship=>"user"}
#                                   block_user GET       /edge/blocks/:block_id/user(.:format)                                                users#get_related_resource {:relationship=>"user", :source=>"blocks"}
#                  block_relationships_blocked GET       /edge/blocks/:block_id/relationships/blocked(.:format)                               blocks#show_relationship {:relationship=>"blocked"}
#                                              PUT|PATCH /edge/blocks/:block_id/relationships/blocked(.:format)                               blocks#update_relationship {:relationship=>"blocked"}
#                                              DELETE    /edge/blocks/:block_id/relationships/blocked(.:format)                               blocks#destroy_relationship {:relationship=>"blocked"}
#                                block_blocked GET       /edge/blocks/:block_id/blocked(.:format)                                             users#get_related_resource {:relationship=>"blocked", :source=>"blocks"}
#                                       blocks GET       /edge/blocks(.:format)                                                               blocks#index
#                                              POST      /edge/blocks(.:format)                                                               blocks#create
#                                        block GET       /edge/blocks/:id(.:format)                                                           blocks#show
#                                              PATCH     /edge/blocks/:id(.:format)                                                           blocks#update
#                                              PUT       /edge/blocks/:id(.:format)                                                           blocks#update
#                                              DELETE    /edge/blocks/:id(.:format)                                                           blocks#destroy
#                  favorite_relationships_user GET       /edge/favorites/:favorite_id/relationships/user(.:format)                            favorites#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/favorites/:favorite_id/relationships/user(.:format)                            favorites#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/favorites/:favorite_id/relationships/user(.:format)                            favorites#destroy_relationship {:relationship=>"user"}
#                                favorite_user GET       /edge/favorites/:favorite_id/user(.:format)                                          users#get_related_resource {:relationship=>"user", :source=>"favorites"}
#                  favorite_relationships_item GET       /edge/favorites/:favorite_id/relationships/item(.:format)                            favorites#show_relationship {:relationship=>"item"}
#                                              PUT|PATCH /edge/favorites/:favorite_id/relationships/item(.:format)                            favorites#update_relationship {:relationship=>"item"}
#                                              DELETE    /edge/favorites/:favorite_id/relationships/item(.:format)                            favorites#destroy_relationship {:relationship=>"item"}
#                                favorite_item GET       /edge/favorites/:favorite_id/item(.:format)                                          items#get_related_resource {:relationship=>"item", :source=>"favorites"}
#                                    favorites GET       /edge/favorites(.:format)                                                            favorites#index
#                                              POST      /edge/favorites(.:format)                                                            favorites#create
#                                     favorite GET       /edge/favorites/:id(.:format)                                                        favorites#show
#                                              PATCH     /edge/favorites/:id(.:format)                                                        favorites#update
#                                              PUT       /edge/favorites/:id(.:format)                                                        favorites#update
#                                              DELETE    /edge/favorites/:id(.:format)                                                        favorites#destroy
#                  episode_relationships_media GET       /edge/episodes/:episode_id/relationships/media(.:format)                             episodes#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/episodes/:episode_id/relationships/media(.:format)                             episodes#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/episodes/:episode_id/relationships/media(.:format)                             episodes#destroy_relationship {:relationship=>"media"}
#                                episode_media GET       /edge/episodes/:episode_id/media(.:format)                                           media#get_related_resource {:relationship=>"media", :source=>"episodes"}
#                                     episodes GET       /edge/episodes(.:format)                                                             episodes#index
#                                              POST      /edge/episodes(.:format)                                                             episodes#create
#                                      episode GET       /edge/episodes/:id(.:format)                                                         episodes#show
#                                              PATCH     /edge/episodes/:id(.:format)                                                         episodes#update
#                                              PUT       /edge/episodes/:id(.:format)                                                         episodes#update
#                                              DELETE    /edge/episodes/:id(.:format)                                                         episodes#destroy
#               list_import_relationships_user GET       /edge/list-imports/:list_import_id/relationships/user(.:format)                      list_imports#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/list-imports/:list_import_id/relationships/user(.:format)                      list_imports#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/list-imports/:list_import_id/relationships/user(.:format)                      list_imports#destroy_relationship {:relationship=>"user"}
#                             list_import_user GET       /edge/list-imports/:list_import_id/user(.:format)                                    users#get_related_resource {:relationship=>"user", :source=>"list_imports"}
#                                 list_imports GET       /edge/list-imports(.:format)                                                         list_imports#index
#                                              POST      /edge/list-imports(.:format)                                                         list_imports#create
#                                  list_import GET       /edge/list-imports/:id(.:format)                                                     list_imports#show
#                                              PATCH     /edge/list-imports/:id(.:format)                                                     list_imports#update
#                                              PUT       /edge/list-imports/:id(.:format)                                                     list_imports#update
#                                              DELETE    /edge/list-imports/:id(.:format)                                                     list_imports#destroy
#           review_relationships_library_entry GET       /edge/reviews/:review_id/relationships/library-entry(.:format)                       reviews#show_relationship {:relationship=>"library_entry"}
#                                              PUT|PATCH /edge/reviews/:review_id/relationships/library-entry(.:format)                       reviews#update_relationship {:relationship=>"library_entry"}
#                                              DELETE    /edge/reviews/:review_id/relationships/library-entry(.:format)                       reviews#destroy_relationship {:relationship=>"library_entry"}
#                         review_library_entry GET       /edge/reviews/:review_id/library-entry(.:format)                                     library_entries#get_related_resource {:relationship=>"library_entry", :source=>"reviews"}
#                   review_relationships_media GET       /edge/reviews/:review_id/relationships/media(.:format)                               reviews#show_relationship {:relationship=>"media"}
#                                              PUT|PATCH /edge/reviews/:review_id/relationships/media(.:format)                               reviews#update_relationship {:relationship=>"media"}
#                                              DELETE    /edge/reviews/:review_id/relationships/media(.:format)                               reviews#destroy_relationship {:relationship=>"media"}
#                                 review_media GET       /edge/reviews/:review_id/media(.:format)                                             media#get_related_resource {:relationship=>"media", :source=>"reviews"}
#                    review_relationships_user GET       /edge/reviews/:review_id/relationships/user(.:format)                                reviews#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/reviews/:review_id/relationships/user(.:format)                                reviews#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/reviews/:review_id/relationships/user(.:format)                                reviews#destroy_relationship {:relationship=>"user"}
#                                  review_user GET       /edge/reviews/:review_id/user(.:format)                                              users#get_related_resource {:relationship=>"user", :source=>"reviews"}
#                                      reviews GET       /edge/reviews(.:format)                                                              reviews#index
#                                              POST      /edge/reviews(.:format)                                                              reviews#create
#                                       review GET       /edge/reviews/:id(.:format)                                                          reviews#show
#                                              PATCH     /edge/reviews/:id(.:format)                                                          reviews#update
#                                              PUT       /edge/reviews/:id(.:format)                                                          reviews#update
#                                              DELETE    /edge/reviews/:id(.:format)                                                          reviews#destroy
#             review_like_relationships_review GET       /edge/review-likes/:review_like_id/relationships/review(.:format)                    review_likes#show_relationship {:relationship=>"review"}
#                                              PUT|PATCH /edge/review-likes/:review_like_id/relationships/review(.:format)                    review_likes#update_relationship {:relationship=>"review"}
#                                              DELETE    /edge/review-likes/:review_like_id/relationships/review(.:format)                    review_likes#destroy_relationship {:relationship=>"review"}
#                           review_like_review GET       /edge/review-likes/:review_like_id/review(.:format)                                  reviews#get_related_resource {:relationship=>"review", :source=>"review_likes"}
#               review_like_relationships_user GET       /edge/review-likes/:review_like_id/relationships/user(.:format)                      review_likes#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/review-likes/:review_like_id/relationships/user(.:format)                      review_likes#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/review-likes/:review_like_id/relationships/user(.:format)                      review_likes#destroy_relationship {:relationship=>"user"}
#                             review_like_user GET       /edge/review-likes/:review_like_id/user(.:format)                                    users#get_related_resource {:relationship=>"user", :source=>"review_likes"}
#                                 review_likes GET       /edge/review-likes(.:format)                                                         review_likes#index
#                                              POST      /edge/review-likes(.:format)                                                         review_likes#create
#                                  review_like GET       /edge/review-likes/:id(.:format)                                                     review_likes#show
#                                              PATCH     /edge/review-likes/:id(.:format)                                                     review_likes#update
#                                              PUT       /edge/review-likes/:id(.:format)                                                     review_likes#update
#                                              DELETE    /edge/review-likes/:id(.:format)                                                     review_likes#destroy
#                role_relationships_user_roles GET       /edge/roles/:role_id/relationships/user-roles(.:format)                              roles#show_relationship {:relationship=>"user_roles"}
#                                              POST      /edge/roles/:role_id/relationships/user-roles(.:format)                              roles#create_relationship {:relationship=>"user_roles"}
#                                              PUT|PATCH /edge/roles/:role_id/relationships/user-roles(.:format)                              roles#update_relationship {:relationship=>"user_roles"}
#                                              DELETE    /edge/roles/:role_id/relationships/user-roles(.:format)                              roles#destroy_relationship {:relationship=>"user_roles"}
#                              role_user_roles GET       /edge/roles/:role_id/user-roles(.:format)                                            user_roles#get_related_resources {:relationship=>"user_roles", :source=>"roles"}
#                  role_relationships_resource GET       /edge/roles/:role_id/relationships/resource(.:format)                                roles#show_relationship {:relationship=>"resource"}
#                                              PUT|PATCH /edge/roles/:role_id/relationships/resource(.:format)                                roles#update_relationship {:relationship=>"resource"}
#                                              DELETE    /edge/roles/:role_id/relationships/resource(.:format)                                roles#destroy_relationship {:relationship=>"resource"}
#                                role_resource GET       /edge/roles/:role_id/resource(.:format)                                              resources#get_related_resource {:relationship=>"resource", :source=>"roles"}
#                                        roles GET       /edge/roles(.:format)                                                                roles#index
#                                              POST      /edge/roles(.:format)                                                                roles#create
#                                         role GET       /edge/roles/:id(.:format)                                                            roles#show
#                                              PATCH     /edge/roles/:id(.:format)                                                            roles#update
#                                              PUT       /edge/roles/:id(.:format)                                                            roles#update
#                                              DELETE    /edge/roles/:id(.:format)                                                            roles#destroy
#                 user_role_relationships_user GET       /edge/user-roles/:user_role_id/relationships/user(.:format)                          user_roles#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/user-roles/:user_role_id/relationships/user(.:format)                          user_roles#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/user-roles/:user_role_id/relationships/user(.:format)                          user_roles#destroy_relationship {:relationship=>"user"}
#                               user_role_user GET       /edge/user-roles/:user_role_id/user(.:format)                                        users#get_related_resource {:relationship=>"user", :source=>"user_roles"}
#                 user_role_relationships_role GET       /edge/user-roles/:user_role_id/relationships/role(.:format)                          user_roles#show_relationship {:relationship=>"role"}
#                                              PUT|PATCH /edge/user-roles/:user_role_id/relationships/role(.:format)                          user_roles#update_relationship {:relationship=>"role"}
#                                              DELETE    /edge/user-roles/:user_role_id/relationships/role(.:format)                          user_roles#destroy_relationship {:relationship=>"role"}
#                               user_role_role GET       /edge/user-roles/:user_role_id/role(.:format)                                        roles#get_related_resource {:relationship=>"role", :source=>"user_roles"}
#                                   user_roles GET       /edge/user-roles(.:format)                                                           user_roles#index
#                                              POST      /edge/user-roles(.:format)                                                           user_roles#create
#                                    user_role GET       /edge/user-roles/:id(.:format)                                                       user_roles#show
#                                              PATCH     /edge/user-roles/:id(.:format)                                                       user_roles#update
#                                              PUT       /edge/user-roles/:id(.:format)                                                       user_roles#update
#                                              DELETE    /edge/user-roles/:id(.:format)                                                       user_roles#destroy
#                 report_relationships_naughty GET       /edge/reports/:report_id/relationships/naughty(.:format)                             reports#show_relationship {:relationship=>"naughty"}
#                                              PUT|PATCH /edge/reports/:report_id/relationships/naughty(.:format)                             reports#update_relationship {:relationship=>"naughty"}
#                                              DELETE    /edge/reports/:report_id/relationships/naughty(.:format)                             reports#destroy_relationship {:relationship=>"naughty"}
#                               report_naughty GET       /edge/reports/:report_id/naughty(.:format)                                           naughties#get_related_resource {:relationship=>"naughty", :source=>"reports"}
#                    report_relationships_user GET       /edge/reports/:report_id/relationships/user(.:format)                                reports#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/reports/:report_id/relationships/user(.:format)                                reports#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/reports/:report_id/relationships/user(.:format)                                reports#destroy_relationship {:relationship=>"user"}
#                                  report_user GET       /edge/reports/:report_id/user(.:format)                                              users#get_related_resource {:relationship=>"user", :source=>"reports"}
#               report_relationships_moderator GET       /edge/reports/:report_id/relationships/moderator(.:format)                           reports#show_relationship {:relationship=>"moderator"}
#                                              PUT|PATCH /edge/reports/:report_id/relationships/moderator(.:format)                           reports#update_relationship {:relationship=>"moderator"}
#                                              DELETE    /edge/reports/:report_id/relationships/moderator(.:format)                           reports#destroy_relationship {:relationship=>"moderator"}
#                             report_moderator GET       /edge/reports/:report_id/moderator(.:format)                                         users#get_related_resource {:relationship=>"moderator", :source=>"reports"}
#                                      reports GET       /edge/reports(.:format)                                                              reports#index
#                                              POST      /edge/reports(.:format)                                                              reports#create
#                                       report GET       /edge/reports/:id(.:format)                                                          reports#show
#                                              PATCH     /edge/reports/:id(.:format)                                                          reports#update
#                                              PUT       /edge/reports/:id(.:format)                                                          reports#update
#                                              DELETE    /edge/reports/:id(.:format)                                                          reports#destroy
#            linked_account_relationships_user GET       /edge/linked-accounts/:linked_account_id/relationships/user(.:format)                linked_accounts#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/linked-accounts/:linked_account_id/relationships/user(.:format)                linked_accounts#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/linked-accounts/:linked_account_id/relationships/user(.:format)                linked_accounts#destroy_relationship {:relationship=>"user"}
#                          linked_account_user GET       /edge/linked-accounts/:linked_account_id/user(.:format)                              users#get_related_resource {:relationship=>"user", :source=>"linked_accounts"}
#                              linked_accounts GET       /edge/linked-accounts(.:format)                                                      linked_accounts#index
#                                              POST      /edge/linked-accounts(.:format)                                                      linked_accounts#create
#                               linked_account GET       /edge/linked-accounts/:id(.:format)                                                  linked_accounts#show
#                                              PATCH     /edge/linked-accounts/:id(.:format)                                                  linked_accounts#update
#                                              PUT       /edge/linked-accounts/:id(.:format)                                                  linked_accounts#update
#                                              DELETE    /edge/linked-accounts/:id(.:format)                                                  linked_accounts#destroy
#              profile_link_relationships_user GET       /edge/profile-links/:profile_link_id/relationships/user(.:format)                    profile_links#show_relationship {:relationship=>"user"}
#                                              PUT|PATCH /edge/profile-links/:profile_link_id/relationships/user(.:format)                    profile_links#update_relationship {:relationship=>"user"}
#                                              DELETE    /edge/profile-links/:profile_link_id/relationships/user(.:format)                    profile_links#destroy_relationship {:relationship=>"user"}
#                            profile_link_user GET       /edge/profile-links/:profile_link_id/user(.:format)                                  users#get_related_resource {:relationship=>"user", :source=>"profile_links"}
# profile_link_relationships_profile_link_site GET       /edge/profile-links/:profile_link_id/relationships/profile-link-site(.:format)       profile_links#show_relationship {:relationship=>"profile_link_site"}
#                                              PUT|PATCH /edge/profile-links/:profile_link_id/relationships/profile-link-site(.:format)       profile_links#update_relationship {:relationship=>"profile_link_site"}
#                                              DELETE    /edge/profile-links/:profile_link_id/relationships/profile-link-site(.:format)       profile_links#destroy_relationship {:relationship=>"profile_link_site"}
#               profile_link_profile_link_site GET       /edge/profile-links/:profile_link_id/profile-link-site(.:format)                     profile_link_sites#get_related_resource {:relationship=>"profile_link_site", :source=>"profile_links"}
#                                profile_links GET       /edge/profile-links(.:format)                                                        profile_links#index
#                                              POST      /edge/profile-links(.:format)                                                        profile_links#create
#                                 profile_link GET       /edge/profile-links/:id(.:format)                                                    profile_links#show
#                                              PATCH     /edge/profile-links/:id(.:format)                                                    profile_links#update
#                                              PUT       /edge/profile-links/:id(.:format)                                                    profile_links#update
#                                              DELETE    /edge/profile-links/:id(.:format)                                                    profile_links#destroy
#                           profile_link_sites GET       /edge/profile-link-sites(.:format)                                                   profile_link_sites#index
#                            profile_link_site GET       /edge/profile-link-sites/:id(.:format)                                               profile_link_sites#show
#     producer_relationships_anime_productions GET       /edge/producers/:producer_id/relationships/anime-productions(.:format)               producers#show_relationship {:relationship=>"anime_productions"}
#                                              POST      /edge/producers/:producer_id/relationships/anime-productions(.:format)               producers#create_relationship {:relationship=>"anime_productions"}
#                                              PUT|PATCH /edge/producers/:producer_id/relationships/anime-productions(.:format)               producers#update_relationship {:relationship=>"anime_productions"}
#                                              DELETE    /edge/producers/:producer_id/relationships/anime-productions(.:format)               producers#destroy_relationship {:relationship=>"anime_productions"}
#                   producer_anime_productions GET       /edge/producers/:producer_id/anime-productions(.:format)                             anime_productions#get_related_resources {:relationship=>"anime_productions", :source=>"producers"}
#                                    producers GET       /edge/producers(.:format)                                                            producers#index
#                                              POST      /edge/producers(.:format)                                                            producers#create
#                                     producer GET       /edge/producers/:id(.:format)                                                        producers#show
#                                              PATCH     /edge/producers/:id(.:format)                                                        producers#update
#                                              PUT       /edge/producers/:id(.:format)                                                        producers#update
#                                              DELETE    /edge/producers/:id(.:format)                                                        producers#destroy
#         anime_production_relationships_anime GET       /edge/anime-productions/:anime_production_id/relationships/anime(.:format)           anime_productions#show_relationship {:relationship=>"anime"}
#                                              PUT|PATCH /edge/anime-productions/:anime_production_id/relationships/anime(.:format)           anime_productions#update_relationship {:relationship=>"anime"}
#                                              DELETE    /edge/anime-productions/:anime_production_id/relationships/anime(.:format)           anime_productions#destroy_relationship {:relationship=>"anime"}
#                       anime_production_anime GET       /edge/anime-productions/:anime_production_id/anime(.:format)                         anime#get_related_resource {:relationship=>"anime", :source=>"anime_productions"}
#      anime_production_relationships_producer GET       /edge/anime-productions/:anime_production_id/relationships/producer(.:format)        anime_productions#show_relationship {:relationship=>"producer"}
#                                              PUT|PATCH /edge/anime-productions/:anime_production_id/relationships/producer(.:format)        anime_productions#update_relationship {:relationship=>"producer"}
#                                              DELETE    /edge/anime-productions/:anime_production_id/relationships/producer(.:format)        anime_productions#destroy_relationship {:relationship=>"producer"}
#                    anime_production_producer GET       /edge/anime-productions/:anime_production_id/producer(.:format)                      producers#get_related_resource {:relationship=>"producer", :source=>"anime_productions"}
#                            anime_productions GET       /edge/anime-productions(.:format)                                                    anime_productions#index
#                                              POST      /edge/anime-productions(.:format)                                                    anime_productions#create
#                             anime_production GET       /edge/anime-productions/:id(.:format)                                                anime_productions#show
#                                              PATCH     /edge/anime-productions/:id(.:format)                                                anime_productions#update
#                                              PUT       /edge/anime-productions/:id(.:format)                                                anime_productions#update
#                                              DELETE    /edge/anime-productions/:id(.:format)                                                anime_productions#destroy
#      media_relationship_relationships_source GET       /edge/media-relationships/:media_relationship_id/relationships/source(.:format)      media_relationships#show_relationship {:relationship=>"source"}
#                                              PUT|PATCH /edge/media-relationships/:media_relationship_id/relationships/source(.:format)      media_relationships#update_relationship {:relationship=>"source"}
#                                              DELETE    /edge/media-relationships/:media_relationship_id/relationships/source(.:format)      media_relationships#destroy_relationship {:relationship=>"source"}
#                    media_relationship_source GET       /edge/media-relationships/:media_relationship_id/source(.:format)                    sources#get_related_resource {:relationship=>"source", :source=>"media_relationships"}
# media_relationship_relationships_destination GET       /edge/media-relationships/:media_relationship_id/relationships/destination(.:format) media_relationships#show_relationship {:relationship=>"destination"}
#                                              PUT|PATCH /edge/media-relationships/:media_relationship_id/relationships/destination(.:format) media_relationships#update_relationship {:relationship=>"destination"}
#                                              DELETE    /edge/media-relationships/:media_relationship_id/relationships/destination(.:format) media_relationships#destroy_relationship {:relationship=>"destination"}
#               media_relationship_destination GET       /edge/media-relationships/:media_relationship_id/destination(.:format)               destinations#get_related_resource {:relationship=>"destination", :source=>"media_relationships"}
#                          media_relationships GET       /edge/media-relationships(.:format)                                                  media_relationships#index
#                                              POST      /edge/media-relationships(.:format)                                                  media_relationships#create
#                           media_relationship GET       /edge/media-relationships/:id(.:format)                                              media_relationships#show
#                                              PATCH     /edge/media-relationships/:id(.:format)                                              media_relationships#update
#                                              PUT       /edge/media-relationships/:id(.:format)                                              media_relationships#update
#                                              DELETE    /edge/media-relationships/:id(.:format)                                              media_relationships#destroy
#          anime_character_relationships_anime GET       /edge/anime-characters/:anime_character_id/relationships/anime(.:format)             anime_characters#show_relationship {:relationship=>"anime"}
#                                              PUT|PATCH /edge/anime-characters/:anime_character_id/relationships/anime(.:format)             anime_characters#update_relationship {:relationship=>"anime"}
#                                              DELETE    /edge/anime-characters/:anime_character_id/relationships/anime(.:format)             anime_characters#destroy_relationship {:relationship=>"anime"}
#                        anime_character_anime GET       /edge/anime-characters/:anime_character_id/anime(.:format)                           anime#get_related_resource {:relationship=>"anime", :source=>"anime_characters"}
#      anime_character_relationships_character GET       /edge/anime-characters/:anime_character_id/relationships/character(.:format)         anime_characters#show_relationship {:relationship=>"character"}
#                                              PUT|PATCH /edge/anime-characters/:anime_character_id/relationships/character(.:format)         anime_characters#update_relationship {:relationship=>"character"}
#                                              DELETE    /edge/anime-characters/:anime_character_id/relationships/character(.:format)         anime_characters#destroy_relationship {:relationship=>"character"}
#                    anime_character_character GET       /edge/anime-characters/:anime_character_id/character(.:format)                       characters#get_related_resource {:relationship=>"character", :source=>"anime_characters"}
#       anime_character_relationships_castings GET       /edge/anime-characters/:anime_character_id/relationships/castings(.:format)          anime_characters#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/anime-characters/:anime_character_id/relationships/castings(.:format)          anime_characters#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/anime-characters/:anime_character_id/relationships/castings(.:format)          anime_characters#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/anime-characters/:anime_character_id/relationships/castings(.:format)          anime_characters#destroy_relationship {:relationship=>"castings"}
#                     anime_character_castings GET       /edge/anime-characters/:anime_character_id/castings(.:format)                        anime_castings#get_related_resources {:relationship=>"castings", :source=>"anime_characters"}
#                             anime_characters GET       /edge/anime-characters(.:format)                                                     anime_characters#index
#                                              POST      /edge/anime-characters(.:format)                                                     anime_characters#create
#                              anime_character GET       /edge/anime-characters/:id(.:format)                                                 anime_characters#show
#                                              PATCH     /edge/anime-characters/:id(.:format)                                                 anime_characters#update
#                                              PUT       /edge/anime-characters/:id(.:format)                                                 anime_characters#update
#                                              DELETE    /edge/anime-characters/:id(.:format)                                                 anime_characters#destroy
#  anime_casting_relationships_anime_character GET       /edge/anime-castings/:anime_casting_id/relationships/anime-character(.:format)       anime_castings#show_relationship {:relationship=>"anime_character"}
#                                              PUT|PATCH /edge/anime-castings/:anime_casting_id/relationships/anime-character(.:format)       anime_castings#update_relationship {:relationship=>"anime_character"}
#                                              DELETE    /edge/anime-castings/:anime_casting_id/relationships/anime-character(.:format)       anime_castings#destroy_relationship {:relationship=>"anime_character"}
#                anime_casting_anime_character GET       /edge/anime-castings/:anime_casting_id/anime-character(.:format)                     anime_characters#get_related_resource {:relationship=>"anime_character", :source=>"anime_castings"}
#           anime_casting_relationships_person GET       /edge/anime-castings/:anime_casting_id/relationships/person(.:format)                anime_castings#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/anime-castings/:anime_casting_id/relationships/person(.:format)                anime_castings#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/anime-castings/:anime_casting_id/relationships/person(.:format)                anime_castings#destroy_relationship {:relationship=>"person"}
#                         anime_casting_person GET       /edge/anime-castings/:anime_casting_id/person(.:format)                              people#get_related_resource {:relationship=>"person", :source=>"anime_castings"}
#         anime_casting_relationships_licensor GET       /edge/anime-castings/:anime_casting_id/relationships/licensor(.:format)              anime_castings#show_relationship {:relationship=>"licensor"}
#                                              PUT|PATCH /edge/anime-castings/:anime_casting_id/relationships/licensor(.:format)              anime_castings#update_relationship {:relationship=>"licensor"}
#                                              DELETE    /edge/anime-castings/:anime_casting_id/relationships/licensor(.:format)              anime_castings#destroy_relationship {:relationship=>"licensor"}
#                       anime_casting_licensor GET       /edge/anime-castings/:anime_casting_id/licensor(.:format)                            producers#get_related_resource {:relationship=>"licensor", :source=>"anime_castings"}
#                                              GET       /edge/anime-castings(.:format)                                                       anime_castings#index
#                                              POST      /edge/anime-castings(.:format)                                                       anime_castings#create
#                                anime_casting GET       /edge/anime-castings/:id(.:format)                                                   anime_castings#show
#                                              PATCH     /edge/anime-castings/:id(.:format)                                                   anime_castings#update
#                                              PUT       /edge/anime-castings/:id(.:format)                                                   anime_castings#update
#                                              DELETE    /edge/anime-castings/:id(.:format)                                                   anime_castings#destroy
#              anime_staff_relationships_anime GET       /edge/anime-staff/:anime_staff_id/relationships/anime(.:format)                      anime_staff#show_relationship {:relationship=>"anime"}
#                                              PUT|PATCH /edge/anime-staff/:anime_staff_id/relationships/anime(.:format)                      anime_staff#update_relationship {:relationship=>"anime"}
#                                              DELETE    /edge/anime-staff/:anime_staff_id/relationships/anime(.:format)                      anime_staff#destroy_relationship {:relationship=>"anime"}
#                            anime_staff_anime GET       /edge/anime-staff/:anime_staff_id/anime(.:format)                                    anime#get_related_resource {:relationship=>"anime", :source=>"anime_staff"}
#             anime_staff_relationships_person GET       /edge/anime-staff/:anime_staff_id/relationships/person(.:format)                     anime_staff#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/anime-staff/:anime_staff_id/relationships/person(.:format)                     anime_staff#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/anime-staff/:anime_staff_id/relationships/person(.:format)                     anime_staff#destroy_relationship {:relationship=>"person"}
#                           anime_staff_person GET       /edge/anime-staff/:anime_staff_id/person(.:format)                                   people#get_related_resource {:relationship=>"person", :source=>"anime_staff"}
#                            anime_staff_index GET       /edge/anime-staff(.:format)                                                          anime_staff#index
#                                              POST      /edge/anime-staff(.:format)                                                          anime_staff#create
#                                  anime_staff GET       /edge/anime-staff/:id(.:format)                                                      anime_staff#show
#                                              PATCH     /edge/anime-staff/:id(.:format)                                                      anime_staff#update
#                                              PUT       /edge/anime-staff/:id(.:format)                                                      anime_staff#update
#                                              DELETE    /edge/anime-staff/:id(.:format)                                                      anime_staff#destroy
#          drama_character_relationships_drama GET       /edge/drama-characters/:drama_character_id/relationships/drama(.:format)             drama_characters#show_relationship {:relationship=>"drama"}
#                                              PUT|PATCH /edge/drama-characters/:drama_character_id/relationships/drama(.:format)             drama_characters#update_relationship {:relationship=>"drama"}
#                                              DELETE    /edge/drama-characters/:drama_character_id/relationships/drama(.:format)             drama_characters#destroy_relationship {:relationship=>"drama"}
#                        drama_character_drama GET       /edge/drama-characters/:drama_character_id/drama(.:format)                           dramas#get_related_resource {:relationship=>"drama", :source=>"drama_characters"}
#      drama_character_relationships_character GET       /edge/drama-characters/:drama_character_id/relationships/character(.:format)         drama_characters#show_relationship {:relationship=>"character"}
#                                              PUT|PATCH /edge/drama-characters/:drama_character_id/relationships/character(.:format)         drama_characters#update_relationship {:relationship=>"character"}
#                                              DELETE    /edge/drama-characters/:drama_character_id/relationships/character(.:format)         drama_characters#destroy_relationship {:relationship=>"character"}
#                    drama_character_character GET       /edge/drama-characters/:drama_character_id/character(.:format)                       characters#get_related_resource {:relationship=>"character", :source=>"drama_characters"}
#       drama_character_relationships_castings GET       /edge/drama-characters/:drama_character_id/relationships/castings(.:format)          drama_characters#show_relationship {:relationship=>"castings"}
#                                              POST      /edge/drama-characters/:drama_character_id/relationships/castings(.:format)          drama_characters#create_relationship {:relationship=>"castings"}
#                                              PUT|PATCH /edge/drama-characters/:drama_character_id/relationships/castings(.:format)          drama_characters#update_relationship {:relationship=>"castings"}
#                                              DELETE    /edge/drama-characters/:drama_character_id/relationships/castings(.:format)          drama_characters#destroy_relationship {:relationship=>"castings"}
#                     drama_character_castings GET       /edge/drama-characters/:drama_character_id/castings(.:format)                        drama_castings#get_related_resources {:relationship=>"castings", :source=>"drama_characters"}
#                             drama_characters GET       /edge/drama-characters(.:format)                                                     drama_characters#index
#                                              POST      /edge/drama-characters(.:format)                                                     drama_characters#create
#                              drama_character GET       /edge/drama-characters/:id(.:format)                                                 drama_characters#show
#                                              PATCH     /edge/drama-characters/:id(.:format)                                                 drama_characters#update
#                                              PUT       /edge/drama-characters/:id(.:format)                                                 drama_characters#update
#                                              DELETE    /edge/drama-characters/:id(.:format)                                                 drama_characters#destroy
#  drama_casting_relationships_drama_character GET       /edge/drama-castings/:drama_casting_id/relationships/drama-character(.:format)       drama_castings#show_relationship {:relationship=>"drama_character"}
#                                              PUT|PATCH /edge/drama-castings/:drama_casting_id/relationships/drama-character(.:format)       drama_castings#update_relationship {:relationship=>"drama_character"}
#                                              DELETE    /edge/drama-castings/:drama_casting_id/relationships/drama-character(.:format)       drama_castings#destroy_relationship {:relationship=>"drama_character"}
#                drama_casting_drama_character GET       /edge/drama-castings/:drama_casting_id/drama-character(.:format)                     drama_characters#get_related_resource {:relationship=>"drama_character", :source=>"drama_castings"}
#           drama_casting_relationships_person GET       /edge/drama-castings/:drama_casting_id/relationships/person(.:format)                drama_castings#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/drama-castings/:drama_casting_id/relationships/person(.:format)                drama_castings#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/drama-castings/:drama_casting_id/relationships/person(.:format)                drama_castings#destroy_relationship {:relationship=>"person"}
#                         drama_casting_person GET       /edge/drama-castings/:drama_casting_id/person(.:format)                              people#get_related_resource {:relationship=>"person", :source=>"drama_castings"}
#         drama_casting_relationships_licensor GET       /edge/drama-castings/:drama_casting_id/relationships/licensor(.:format)              drama_castings#show_relationship {:relationship=>"licensor"}
#                                              PUT|PATCH /edge/drama-castings/:drama_casting_id/relationships/licensor(.:format)              drama_castings#update_relationship {:relationship=>"licensor"}
#                                              DELETE    /edge/drama-castings/:drama_casting_id/relationships/licensor(.:format)              drama_castings#destroy_relationship {:relationship=>"licensor"}
#                       drama_casting_licensor GET       /edge/drama-castings/:drama_casting_id/licensor(.:format)                            producers#get_related_resource {:relationship=>"licensor", :source=>"drama_castings"}
#                                              GET       /edge/drama-castings(.:format)                                                       drama_castings#index
#                                              POST      /edge/drama-castings(.:format)                                                       drama_castings#create
#                                drama_casting GET       /edge/drama-castings/:id(.:format)                                                   drama_castings#show
#                                              PATCH     /edge/drama-castings/:id(.:format)                                                   drama_castings#update
#                                              PUT       /edge/drama-castings/:id(.:format)                                                   drama_castings#update
#                                              DELETE    /edge/drama-castings/:id(.:format)                                                   drama_castings#destroy
#              drama_staff_relationships_drama GET       /edge/drama-staff/:drama_staff_id/relationships/drama(.:format)                      drama_staff#show_relationship {:relationship=>"drama"}
#                                              PUT|PATCH /edge/drama-staff/:drama_staff_id/relationships/drama(.:format)                      drama_staff#update_relationship {:relationship=>"drama"}
#                                              DELETE    /edge/drama-staff/:drama_staff_id/relationships/drama(.:format)                      drama_staff#destroy_relationship {:relationship=>"drama"}
#                            drama_staff_drama GET       /edge/drama-staff/:drama_staff_id/drama(.:format)                                    dramas#get_related_resource {:relationship=>"drama", :source=>"drama_staff"}
#             drama_staff_relationships_person GET       /edge/drama-staff/:drama_staff_id/relationships/person(.:format)                     drama_staff#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/drama-staff/:drama_staff_id/relationships/person(.:format)                     drama_staff#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/drama-staff/:drama_staff_id/relationships/person(.:format)                     drama_staff#destroy_relationship {:relationship=>"person"}
#                           drama_staff_person GET       /edge/drama-staff/:drama_staff_id/person(.:format)                                   people#get_related_resource {:relationship=>"person", :source=>"drama_staff"}
#                            drama_staff_index GET       /edge/drama-staff(.:format)                                                          drama_staff#index
#                                              POST      /edge/drama-staff(.:format)                                                          drama_staff#create
#                                  drama_staff GET       /edge/drama-staff/:id(.:format)                                                      drama_staff#show
#                                              PATCH     /edge/drama-staff/:id(.:format)                                                      drama_staff#update
#                                              PUT       /edge/drama-staff/:id(.:format)                                                      drama_staff#update
#                                              DELETE    /edge/drama-staff/:id(.:format)                                                      drama_staff#destroy
#          manga_character_relationships_manga GET       /edge/manga-characters/:manga_character_id/relationships/manga(.:format)             manga_characters#show_relationship {:relationship=>"manga"}
#                                              PUT|PATCH /edge/manga-characters/:manga_character_id/relationships/manga(.:format)             manga_characters#update_relationship {:relationship=>"manga"}
#                                              DELETE    /edge/manga-characters/:manga_character_id/relationships/manga(.:format)             manga_characters#destroy_relationship {:relationship=>"manga"}
#                        manga_character_manga GET       /edge/manga-characters/:manga_character_id/manga(.:format)                           manga#get_related_resource {:relationship=>"manga", :source=>"manga_characters"}
#      manga_character_relationships_character GET       /edge/manga-characters/:manga_character_id/relationships/character(.:format)         manga_characters#show_relationship {:relationship=>"character"}
#                                              PUT|PATCH /edge/manga-characters/:manga_character_id/relationships/character(.:format)         manga_characters#update_relationship {:relationship=>"character"}
#                                              DELETE    /edge/manga-characters/:manga_character_id/relationships/character(.:format)         manga_characters#destroy_relationship {:relationship=>"character"}
#                    manga_character_character GET       /edge/manga-characters/:manga_character_id/character(.:format)                       characters#get_related_resource {:relationship=>"character", :source=>"manga_characters"}
#                             manga_characters GET       /edge/manga-characters(.:format)                                                     manga_characters#index
#                                              POST      /edge/manga-characters(.:format)                                                     manga_characters#create
#                              manga_character GET       /edge/manga-characters/:id(.:format)                                                 manga_characters#show
#                                              PATCH     /edge/manga-characters/:id(.:format)                                                 manga_characters#update
#                                              PUT       /edge/manga-characters/:id(.:format)                                                 manga_characters#update
#                                              DELETE    /edge/manga-characters/:id(.:format)                                                 manga_characters#destroy
#              manga_staff_relationships_manga GET       /edge/manga-staff/:manga_staff_id/relationships/manga(.:format)                      manga_staff#show_relationship {:relationship=>"manga"}
#                                              PUT|PATCH /edge/manga-staff/:manga_staff_id/relationships/manga(.:format)                      manga_staff#update_relationship {:relationship=>"manga"}
#                                              DELETE    /edge/manga-staff/:manga_staff_id/relationships/manga(.:format)                      manga_staff#destroy_relationship {:relationship=>"manga"}
#                            manga_staff_manga GET       /edge/manga-staff/:manga_staff_id/manga(.:format)                                    manga#get_related_resource {:relationship=>"manga", :source=>"manga_staff"}
#             manga_staff_relationships_person GET       /edge/manga-staff/:manga_staff_id/relationships/person(.:format)                     manga_staff#show_relationship {:relationship=>"person"}
#                                              PUT|PATCH /edge/manga-staff/:manga_staff_id/relationships/person(.:format)                     manga_staff#update_relationship {:relationship=>"person"}
#                                              DELETE    /edge/manga-staff/:manga_staff_id/relationships/person(.:format)                     manga_staff#destroy_relationship {:relationship=>"person"}
#                           manga_staff_person GET       /edge/manga-staff/:manga_staff_id/person(.:format)                                   people#get_related_resource {:relationship=>"person", :source=>"manga_staff"}
#                            manga_staff_index GET       /edge/manga-staff(.:format)                                                          manga_staff#index
#                                              POST      /edge/manga-staff(.:format)                                                          manga_staff#create
#                                  manga_staff GET       /edge/manga-staff/:id(.:format)                                                      manga_staff#show
#                                              PATCH     /edge/manga-staff/:id(.:format)                                                      manga_staff#update
#                                              PUT       /edge/manga-staff/:id(.:format)                                                      manga_staff#update
#                                              DELETE    /edge/manga-staff/:id(.:format)                                                      manga_staff#destroy
#                                     activity DELETE    /edge/activities/:id(.:format)                                                       activities#destroy
#                                              GET       /edge/feeds/:group/:id(.:format)                                                     feeds#show
#                                              POST      /edge/feeds/:group/:id/_read(.:format)                                               feeds#mark_read
#                                              POST      /edge/feeds/:group/:id/_seen(.:format)                                               feeds#mark_seen
#                                              DELETE    /edge/feeds/:group/:id/activities/:uuid(.:format)                                    feeds#destroy_activity
#                                              GET       /edge/trending/:namespace(.:format)                                                  trending#index
#                               users__recover POST      /edge/users/_recover(.:format)                                                       users#recover
#                                              GET       /edge/anime/:anime_id/_languages(.:format)                                           anime#languages
#                               debug_dump_all GET       /debug/dump_all(.:format)                                                            debug#dump_all
#                               debug_trace_on POST      /debug/trace_on(.:format)                                                            debug#trace_on
#                                debug_gc_info GET       /debug/gc_info(.:format)                                                             debug#gc_info
#                               user__prodsync POST      /user/_prodsync(.:format)                                                            users#prod_sync
#                                              GET       /oauth/authorize/:code(.:format)                                                     doorkeeper/authorizations#show
#                          oauth_authorization GET       /oauth/authorize(.:format)                                                           doorkeeper/authorizations#new
#                                              POST      /oauth/authorize(.:format)                                                           doorkeeper/authorizations#create
#                                              DELETE    /oauth/authorize(.:format)                                                           doorkeeper/authorizations#destroy
#                                  oauth_token POST      /oauth/token(.:format)                                                               doorkeeper/tokens#create
#                                 oauth_revoke POST      /oauth/revoke(.:format)                                                              doorkeeper/tokens#revoke
#                           oauth_applications GET       /oauth/applications(.:format)                                                        doorkeeper/applications#index
#                                              POST      /oauth/applications(.:format)                                                        doorkeeper/applications#create
#                        new_oauth_application GET       /oauth/applications/new(.:format)                                                    doorkeeper/applications#new
#                       edit_oauth_application GET       /oauth/applications/:id/edit(.:format)                                               doorkeeper/applications#edit
#                            oauth_application GET       /oauth/applications/:id(.:format)                                                    doorkeeper/applications#show
#                                              PATCH     /oauth/applications/:id(.:format)                                                    doorkeeper/applications#update
#                                              PUT       /oauth/applications/:id(.:format)                                                    doorkeeper/applications#update
#                                              DELETE    /oauth/applications/:id(.:format)                                                    doorkeeper/applications#destroy
#                oauth_authorized_applications GET       /oauth/authorized_applications(.:format)                                             doorkeeper/authorized_applications#index
#                 oauth_authorized_application DELETE    /oauth/authorized_applications/:id(.:format)                                         doorkeeper/authorized_applications#destroy
#                             oauth_token_info GET       /oauth/token/info(.:format)                                                          doorkeeper/token_info#show
#                                         root GET       /                                                                                    home#index
#
# Routes for RailsAdmin::Engine:
#     dashboard GET         /                                      rails_admin/main#dashboard
#         index GET|POST    /:model_name(.:format)                 rails_admin/main#index
# history_index GET         /:model_name/history(.:format)         rails_admin/main#history_index
#           new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#        export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
#   bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
#   bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#  history_show GET         /:model_name/:id/history(.:format)     rails_admin/main#history_show
#          show GET         /:model_name/:id(.:format)             rails_admin/main#show
#          edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#        delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
#   show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
#

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :sessions, only: [:new, :create]
  scope '/edge' do
    jsonapi_resources :library_entries
    jsonapi_resources :anime
    jsonapi_resources :manga
    jsonapi_resources :drama
    jsonapi_resources :users
    jsonapi_resources :follows do
      post :import_from_facebook, on: :collection
      post :import_from_twitter, on: :collection
    end
    jsonapi_resources :media_follows
    jsonapi_resources :characters
    jsonapi_resources :people
    jsonapi_resources :castings
    jsonapi_resources :genres
    jsonapi_resources :streamers
    jsonapi_resources :streaming_links
    jsonapi_resources :franchises
    jsonapi_resources :installments
    jsonapi_resources :mappings
    jsonapi_resources :posts
    jsonapi_resources :comments
    jsonapi_resources :post_likes
    jsonapi_resources :comment_likes
    jsonapi_resources :blocks
    jsonapi_resources :favorites
    jsonapi_resources :episodes
    jsonapi_resources :list_imports
    jsonapi_resources :reviews
    jsonapi_resources :review_likes
    jsonapi_resources :roles
    jsonapi_resources :user_roles
    jsonapi_resources :reports
    jsonapi_resources :linked_accounts
    jsonapi_resources :profile_links
    jsonapi_resources :profile_link_sites
    jsonapi_resources :producers
    jsonapi_resources :anime_productions
    jsonapi_resources :media_relationships
    jsonapi_resources :anime_characters
    jsonapi_resources :anime_castings
    jsonapi_resources :anime_staff
    jsonapi_resources :drama_characters
    jsonapi_resources :drama_castings
    jsonapi_resources :drama_staff
    jsonapi_resources :manga_characters
    jsonapi_resources :manga_staff
    resources :activities, only: %i[destroy]
    get '/feeds/:group/:id', to: 'feeds#show'
    post '/feeds/:group/:id/_read', to: 'feeds#mark_read'
    post '/feeds/:group/:id/_seen', to: 'feeds#mark_seen'
    delete '/feeds/:group/:id/activities/:uuid', to: 'feeds#destroy_activity'
    get '/trending/:namespace', to: 'trending#index'
    post '/users/_recover', to: 'users#recover'
    get '/anime/:anime_id/_languages', to: 'anime#languages'
  end

  get '/debug/dump_all', to: 'debug#dump_all'
  post '/debug/trace_on', to: 'debug#trace_on'
  get '/debug/gc_info', to: 'debug#gc_info'
  post '/user/_prodsync', to: 'users#prod_sync'
  use_doorkeeper

  root to: 'home#index'
end
