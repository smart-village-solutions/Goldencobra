class InstallGoldencobra < ActiveRecord::Migration
  def change

    #Active Admin
    create_table "active_admin_comments", force: :cascade do |t|
      t.integer  "resource_id",   limit: 4,     null: false
      t.string   "resource_type", limit: 255,   null: false
      t.integer  "author_id",     limit: 4
      t.string   "author_type",   limit: 255
      t.text     "body",          limit: 65535
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.string   "namespace",     limit: 255
    end

    add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

    create_table "friendly_id_slugs", force: :cascade do |t|
      t.string   "slug",           limit: 255, null: false
      t.integer  "sluggable_id",   limit: 4,   null: false
      t.string   "sluggable_type", limit: 40
      t.datetime "created_at"
    end

    add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
    add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

    create_table "goldencobra_article_authors", force: :cascade do |t|
      t.integer  "article_id", limit: 4
      t.integer  "author_id",  limit: 4
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end

    create_table "goldencobra_article_images", force: :cascade do |t|
      t.integer  "article_id", limit: 4
      t.integer  "image_id",   limit: 4
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
      t.string   "position",   limit: 255
    end

    create_table "goldencobra_article_widgets", force: :cascade do |t|
      t.integer  "article_id", limit: 4
      t.integer  "widget_id",  limit: 4
      t.datetime "created_at",           null: false
      t.datetime "updated_at",           null: false
    end

    create_table "goldencobra_articles", force: :cascade do |t|
      t.string   "title",                            limit: 255
      t.datetime "created_at",                                                                     null: false
      t.datetime "updated_at",                                                                     null: false
      t.string   "url_name",                         limit: 255
      t.string   "slug",                             limit: 255
      t.text     "content",                          limit: 65535
      t.text     "teaser",                           limit: 65535
      t.string   "ancestry",                         limit: 255
      t.boolean  "startpage",                                      default: false
      t.boolean  "active",                                         default: true
      t.string   "subtitle",                         limit: 255
      t.text     "summary",                          limit: 65535
      t.text     "context_info",                     limit: 65535
      t.string   "canonical_url",                    limit: 255
      t.boolean  "robots_no_index",                                default: false
      t.string   "breadcrumb",                       limit: 255
      t.string   "template_file",                    limit: 255
      t.integer  "article_for_index_id",             limit: 4
      t.integer  "article_for_index_levels",         limit: 4,     default: 0
      t.integer  "article_for_index_count",          limit: 4,     default: 0
      t.boolean  "enable_social_sharing"
      t.boolean  "article_for_index_images",                       default: false
      t.boolean  "cacheable",                                      default: true
      t.string   "image_gallery_tags",               limit: 255
      t.string   "article_type",                     limit: 255
      t.string   "external_url_redirect",            limit: 255
      t.string   "index_of_articles_tagged_with",    limit: 255
      t.string   "sort_order",                       limit: 255
      t.boolean  "reverse_sort"
      t.integer  "sorter_limit",                     limit: 4
      t.string   "not_tagged_with",                  limit: 255
      t.boolean  "use_frontend_tags",                              default: false
      t.string   "dynamic_redirection",              limit: 255,   default: "false"
      t.boolean  "redirection_target_in_new_window",               default: false
      t.boolean  "commentable",                                    default: false
      t.datetime "active_since",                                   default: '2014-10-03 07:43:07'
      t.string   "redirect_link_title",              limit: 255
      t.string   "display_index_types",              limit: 255,   default: "show"
      t.integer  "creator_id",                       limit: 4
      t.string   "external_referee_id",              limit: 255
      t.string   "external_referee_ip",              limit: 255
      t.datetime "external_updated_at"
      t.string   "image_gallery_type",               limit: 255,   default: "lightbox"
      t.text     "url_path",                         limit: 65535
      t.integer  "global_sorting_id",                limit: 4,     default: 0
    end

    add_index "goldencobra_articles", ["active"], name: "index_goldencobra_articles_on_active", using: :btree
    add_index "goldencobra_articles", ["ancestry"], name: "index_goldencobra_articles_on_ancestry", using: :btree
    add_index "goldencobra_articles", ["breadcrumb"], name: "index_goldencobra_articles_on_breadcrumb", using: :btree
    add_index "goldencobra_articles", ["slug"], name: "index_goldencobra_articles_on_slug", using: :btree
    add_index "goldencobra_articles", ["title"], name: "index_goldencobra_articles_on_title", using: :btree
    add_index "goldencobra_articles", ["url_name"], name: "index_goldencobra_articles_on_url_name", using: :btree
    add_index "goldencobra_articles", ["url_path"], name: "index_goldencobra_articles_on_url_path", length: {"url_path"=>200}, using: :btree

    create_table "goldencobra_articletype_fields", force: :cascade do |t|
      t.integer  "articletype_group_id", limit: 4
      t.string   "fieldname",            limit: 255
      t.integer  "sorter",               limit: 4,   default: 0
      t.string   "class_name",           limit: 255
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
    end

    create_table "goldencobra_articletype_groups", force: :cascade do |t|
      t.string   "title",          limit: 255
      t.boolean  "expert",                     default: false
      t.boolean  "foldable",                   default: true
      t.boolean  "closed",                     default: true
      t.integer  "sorter",         limit: 4,   default: 0
      t.integer  "articletype_id", limit: 4
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.string   "position",       limit: 255, default: "first_block"
    end

    create_table "goldencobra_articletypes", force: :cascade do |t|
      t.string   "name",                  limit: 255
      t.string   "default_template_file", limit: 255
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
    end

    create_table "goldencobra_authors", force: :cascade do |t|
      t.string   "firstname",  limit: 255
      t.string   "lastname",   limit: 255
      t.string   "email",      limit: 255
      t.string   "googleplus", limit: 255
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end

    create_table "goldencobra_comments", force: :cascade do |t|
      t.integer  "article_id",       limit: 4
      t.integer  "commentator_id",   limit: 4
      t.string   "commentator_type", limit: 255
      t.text     "content",          limit: 65535
      t.boolean  "active",                         default: true
      t.boolean  "approved",                       default: false
      t.boolean  "reported",                       default: false
      t.string   "ancestry",         limit: 255
      t.datetime "created_at",                                     null: false
      t.datetime "updated_at",                                     null: false
    end

    create_table "goldencobra_domains", force: :cascade do |t|
      t.string   "hostname",   limit: 255
      t.string   "title",      limit: 255
      t.string   "client",     limit: 255
      t.datetime "created_at",                             null: false
      t.datetime "updated_at",                             null: false
      t.string   "url_prefix", limit: 255
      t.boolean  "main",                   default: false
    end

    create_table "goldencobra_helps", force: :cascade do |t|
      t.string   "title",       limit: 255
      t.text     "description", limit: 65535
      t.string   "url",         limit: 255
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    create_table "goldencobra_import_metadata", force: :cascade do |t|
      t.string   "database_owner",            limit: 255
      t.datetime "exported_at"
      t.string   "database_admin_first_name", limit: 255
      t.string   "database_admin_last_name",  limit: 255
      t.string   "database_admin_phone",      limit: 255
      t.string   "database_admin_email",      limit: 255
      t.integer  "importmetatagable_id",      limit: 4
      t.string   "importmetatagable_type",    limit: 255
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
    end

    create_table "goldencobra_imports", force: :cascade do |t|
      t.text     "assignment",        limit: 65535
      t.string   "target_model",      limit: 255
      t.boolean  "successful"
      t.integer  "upload_id",         limit: 4
      t.string   "separator",         limit: 255,   default: ","
      t.text     "result",            limit: 65535
      t.datetime "created_at",                                    null: false
      t.datetime "updated_at",                                    null: false
      t.string   "encoding_type",     limit: 255
      t.text     "assignment_groups", limit: 65535
    end

    create_table "goldencobra_link_checkers", force: :cascade do |t|
      t.integer  "article_id",     limit: 4
      t.text     "target_link",    limit: 65535
      t.text     "position",       limit: 65535
      t.string   "response_code",  limit: 255
      t.string   "response_time",  limit: 255
      t.text     "response_error", limit: 65535
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end

    create_table "goldencobra_locations", force: :cascade do |t|
      t.string   "lat",              limit: 255
      t.string   "lng",              limit: 255
      t.string   "street",           limit: 255
      t.string   "city",             limit: 255
      t.string   "zip",              limit: 255
      t.string   "region",           limit: 255
      t.string   "country",          limit: 255
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
      t.string   "title",            limit: 255
      t.string   "locateable_type",  limit: 255
      t.integer  "locateable_id",    limit: 4
      t.string   "street_number",    limit: 255
      t.boolean  "manual_geocoding",             default: false
    end

    create_table "goldencobra_menues", force: :cascade do |t|
      t.string   "title",               limit: 255
      t.string   "target",              limit: 255
      t.string   "css_class",           limit: 255
      t.boolean  "active",                            default: true
      t.datetime "created_at",                                        null: false
      t.datetime "updated_at",                                        null: false
      t.string   "ancestry",            limit: 255
      t.integer  "sorter",              limit: 4,     default: 0
      t.text     "description",         limit: 65535
      t.string   "call_to_action_name", limit: 255
      t.string   "description_title",   limit: 255
      t.integer  "image_id",            limit: 4
      t.integer  "ancestry_depth",      limit: 4,     default: 0
      t.boolean  "remote",                            default: false
    end

    add_index "goldencobra_menues", ["active"], name: "index_goldencobra_articles_on_active", using: :btree
    add_index "goldencobra_menues", ["ancestry"], name: "index_goldencobra_menues_on_ancestry", using: :btree
    add_index "goldencobra_menues", ["target"], name: "index_goldencobra_articles_on_target", using: :btree

    create_table "goldencobra_metatags", force: :cascade do |t|
      t.string   "name",             limit: 255
      t.string   "value",            limit: 255
      t.integer  "article_id",       limit: 4
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.integer  "metatagable_id",   limit: 4
      t.string   "metatagable_type", limit: 255
    end

    create_table "goldencobra_permissions", force: :cascade do |t|
      t.string   "action",        limit: 255
      t.string   "subject_class", limit: 255
      t.string   "subject_id",    limit: 255
      t.integer  "role_id",       limit: 4
      t.integer  "sorter_id",     limit: 4,   default: 0
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
      t.integer  "operator_id",   limit: 4
      t.integer  "domain_id",     limit: 4
    end

    create_table "goldencobra_redirectors", force: :cascade do |t|
      t.text     "source_url",        limit: 65535
      t.text     "target_url",        limit: 65535
      t.integer  "redirection_code",  limit: 4,     default: 301
      t.boolean  "active",                          default: true
      t.boolean  "ignore_url_params",               default: true
      t.datetime "created_at",                                     null: false
      t.datetime "updated_at",                                     null: false
    end

    add_index "goldencobra_redirectors", ["active"], name: "index_goldencobra_articles_on_active", using: :btree
    add_index "goldencobra_redirectors", ["source_url"], name: "index_goldencobra_articles_on_source_url", length: {"source_url"=>200}, using: :btree
    add_index "goldencobra_redirectors", ["target_url"], name: "index_goldencobra_articles_on_target_url", length: {"target_url"=>200}, using: :btree

    create_table "goldencobra_roles", force: :cascade do |t|
      t.string   "name",                 limit: 255
      t.text     "description",          limit: 65535
      t.datetime "created_at",                                            null: false
      t.datetime "updated_at",                                            null: false
      t.string   "redirect_after_login", limit: 255,   default: "reload"
    end

    create_table "goldencobra_roles_users", id: false, force: :cascade do |t|
      t.integer "operator_id",   limit: 4
      t.integer "role_id",       limit: 4
      t.string  "operator_type", limit: 255, default: "User"
    end

    create_table "goldencobra_settings", force: :cascade do |t|
      t.string   "title",      limit: 255
      t.string   "value",      limit: 255
      t.string   "ancestry",   limit: 255
      t.datetime "created_at",                                null: false
      t.datetime "updated_at",                                null: false
      t.string   "data_type",  limit: 255, default: "string"
    end

    add_index "goldencobra_settings", ["ancestry"], name: "index_goldencobra_articles_on_ancestry", using: :btree
    add_index "goldencobra_settings", ["title", "ancestry"], name: "index_goldencobra_articles_on_title_and_ancestry", using: :btree
    add_index "goldencobra_settings", ["title"], name: "index_goldencobra_articles_on_title", using: :btree

    create_table "goldencobra_trackings", force: :cascade do |t|
      t.text     "request",        limit: 65535
      t.string   "session_id",     limit: 255
      t.string   "referer",        limit: 255
      t.string   "url",            limit: 255
      t.string   "ip",             limit: 255
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.string   "user_agent",     limit: 255
      t.string   "language",       limit: 255
      t.string   "path",           limit: 255
      t.string   "page_duration",  limit: 255
      t.string   "view_duration",  limit: 255
      t.string   "db_duration",    limit: 255
      t.text     "url_paremeters", limit: 65535
      t.string   "utm_source",     limit: 255
      t.string   "utm_medium",     limit: 255
      t.string   "utm_term",       limit: 255
      t.string   "utm_content",    limit: 255
      t.string   "utm_campaign",   limit: 255
      t.string   "location",       limit: 255
    end

    create_table "goldencobra_uploads", force: :cascade do |t|
      t.string   "source",             limit: 255
      t.string   "rights",             limit: 255
      t.text     "description",        limit: 65535
      t.string   "image_file_name",    limit: 255
      t.string   "image_content_type", limit: 255
      t.integer  "image_file_size",    limit: 4
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
      t.integer  "attachable_id",      limit: 4
      t.string   "attachable_type",    limit: 255
      t.string   "alt_text",           limit: 255
      t.integer  "sorter_number",      limit: 4
      t.string   "image_remote_url",   limit: 255
    end

    create_table "goldencobra_vita", force: :cascade do |t|
      t.integer  "loggable_id",   limit: 4
      t.string   "loggable_type", limit: 255
      t.integer  "user_id",       limit: 4
      t.string   "title",         limit: 255
      t.text     "description",   limit: 65535
      t.datetime "created_at",                              null: false
      t.datetime "updated_at",                              null: false
      t.integer  "status_cd",     limit: 4,     default: 0
    end

    add_index "goldencobra_vita", ["loggable_id"], name: "index_goldencobra_vita_on_loggable_id", using: :btree

    create_table "goldencobra_widgets", force: :cascade do |t|
      t.string   "title",                       limit: 255
      t.text     "content",                     limit: 65535
      t.string   "css_name",                    limit: 255
      t.boolean  "active"
      t.datetime "created_at",                                null: false
      t.datetime "updated_at",                                null: false
      t.string   "id_name",                     limit: 255
      t.integer  "sorter",                      limit: 4
      t.text     "mobile_content",              limit: 65535
      t.string   "teaser",                      limit: 255
      t.boolean  "default"
      t.text     "description",                 limit: 65535
      t.string   "offline_days",                limit: 255
      t.boolean  "offline_time_active"
      t.text     "alternative_content",         limit: 65535
      t.date     "offline_date_start"
      t.date     "offline_date_end"
      t.text     "offline_time_week_start_end", limit: 65535
    end

    add_index "goldencobra_widgets", ["active"], name: "index_goldencobra_articles_on_active", using: :btree
    add_index "goldencobra_widgets", ["title", "active"], name: "index_goldencobra_articles_on_title_and_active", using: :btree

    create_table "sessions", force: :cascade do |t|
      t.string   "session_id", limit: 255,   null: false
      t.text     "data",       limit: 65535
      t.datetime "created_at",               null: false
      t.datetime "updated_at",               null: false
    end

    add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
    add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

    create_table "taggings", force: :cascade do |t|
      t.integer  "tag_id",        limit: 4
      t.integer  "taggable_id",   limit: 4
      t.string   "taggable_type", limit: 255
      t.integer  "tagger_id",     limit: 4
      t.string   "tagger_type",   limit: 255
      t.string   "context",       limit: 128
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

    create_table "tags", force: :cascade do |t|
      t.string  "name",           limit: 255
      t.integer "taggings_count", limit: 4
    end

    create_table "translations", force: :cascade do |t|
      t.string   "locale",         limit: 255
      t.string   "key",            limit: 255
      t.text     "value",          limit: 65535
      t.text     "interpolations", limit: 65535
      t.boolean  "is_proc",                      default: false
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
    end

    create_table "users", force: :cascade do |t|
      t.string   "email",                  limit: 255, default: "",    null: false
      t.string   "encrypted_password",     limit: 255, default: "",    null: false
      t.string   "reset_password_token",   limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          limit: 4,   default: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip",     limit: 255
      t.string   "last_sign_in_ip",        limit: 255
      t.string   "password_salt",          limit: 255
      t.string   "confirmation_token",     limit: 255
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email",      limit: 255
      t.integer  "failed_attempts",        limit: 4,   default: 0
      t.string   "unlock_token",           limit: 255
      t.datetime "locked_at"
      t.string   "authentication_token",   limit: 255
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.boolean  "gender"
      t.string   "title",                  limit: 255
      t.string   "firstname",              limit: 255
      t.string   "lastname",               limit: 255
      t.string   "function",               limit: 255
      t.string   "phone",                  limit: 255
      t.string   "fax",                    limit: 255
      t.string   "facebook",               limit: 255
      t.string   "twitter",                limit: 255
      t.string   "linkedin",               limit: 255
      t.string   "xing",                   limit: 255
      t.string   "googleplus",             limit: 255
      t.boolean  "enable_expert_mode",                 default: false
    end

    add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

    create_table "versions", force: :cascade do |t|
      t.string   "item_type",  limit: 255,        null: false
      t.integer  "item_id",    limit: 4,          null: false
      t.string   "event",      limit: 255,        null: false
      t.string   "whodunnit",  limit: 255
      t.text     "object",     limit: 4294967295
      t.datetime "created_at"
    end

    add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

    create_table "visitors", force: :cascade do |t|
      t.string   "email",                  limit: 255, default: "",    null: false
      t.string   "encrypted_password",     limit: 255, default: "",    null: false
      t.string   "reset_password_token",   limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          limit: 4,   default: 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip",     limit: 255
      t.string   "last_sign_in_ip",        limit: 255
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.string   "first_name",             limit: 255
      t.string   "last_name",              limit: 255
      t.string   "provider",               limit: 255
      t.string   "uid",                    limit: 255
      t.boolean  "agb",                                default: false
      t.boolean  "newsletter"
      t.string   "confirmation_token",     limit: 255
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email",      limit: 255
      t.integer  "failed_attempts",        limit: 4
      t.string   "unlock_token",           limit: 255
      t.datetime "locked_at"
      t.string   "authentication_token",   limit: 255
      t.string   "username",               limit: 255
      t.string   "loginable_type",         limit: 255
      t.integer  "loginable_id",           limit: 4
    end

    add_index "visitors", ["email"], name: "index_visitors_on_email", unique: true, using: :btree
    add_index "visitors", ["reset_password_token"], name: "index_visitors_on_reset_password_token", unique: true, using: :btree

  end
end
