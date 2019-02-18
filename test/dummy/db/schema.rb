# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_31_120240) do

  create_table "active_admin_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.text "body", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id"
  end

  create_table "awards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_id"
    t.string "anchor"
    t.index ["title"], name: "index_awards_on_title"
  end

  create_table "best_practice_awards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "award_id"
    t.string "award_category"
    t.integer "award_winning_year"
    t.text "award_category_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["award_id", "best_practice_id"], name: "index_best_practice_awards_on_award_id_and_best_practice_id"
  end

  create_table "best_practices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "abstract", limit: 16777215
    t.text "background_and_objectives", limit: 16777215
    t.text "implementation", limit: 16777215
    t.text "financing_and_resources", limit: 16777215
    t.text "results_and_impacts", limit: 16777215
    t.text "barriers_and_conflicts", limit: 16777215
    t.text "lessons_learned_and_transferability", limit: 16777215
    t.text "references", limit: 16777215
    t.text "internet_links", limit: 16777215
    t.text "national_context", limit: 16777215
    t.integer "size_cluster_id"
    t.integer "project_area_id"
    t.date "duration_start"
    t.date "duration_end"
    t.integer "article_id"
    t.integer "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.boolean "owner_hidden", default: false
    t.integer "country_id"
    t.float "zoom_level"
    t.float "lat"
    t.float "lon"
    t.integer "like_count", default: 0
  end

  create_table "bestpractice_experts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "expert_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "bestpractice_instruments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "instrument_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bestpractice_mainactors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "main_actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bestpractice_regions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bestpractice_sustainable_development_goals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "sustainable_development_goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["best_practice_id", "sustainable_development_goal_id"], name: "index_bestpractice_sustainable_dev_goals_on_bp_id_and_sdg_id"
  end

  create_table "bestpractice_topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "best_practice_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "size_and_population_development", limit: 16777215
    t.text "population_composition", limit: 16777215
    t.text "main_functions", limit: 16777215
    t.text "main_industries", limit: 16777215
    t.text "sources_for_city_budget", limit: 16777215
    t.text "political_structure", limit: 16777215
    t.text "administrative_structure", limit: 16777215
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "metropolis_city"
    t.integer "country_id"
  end

  create_table "city_experts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "city_id"
    t.integer "expert_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_type"
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_countries_on_title"
  end

  create_table "country_regions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "region_id"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "expert_instruments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "expert_id"
    t.integer "instrument_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expert_languageskills", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "expert_id"
    t.integer "language_skill_id"
    t.integer "skill_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expert_regions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "expert_id"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expert_topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "expert_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "academic_title"
    t.string "profession"
    t.string "company_name"
    t.string "company_url"
    t.string "phone_country_code"
    t.string "phone_area_code"
    t.string "phone_number"
    t.string "email"
    t.string "linkedin"
    t.string "xing"
    t.string "facebook"
    t.string "twitter"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "expertise", limit: 16777215
    t.text "reference", limit: 16777215
    t.text "additional_language_skills", limit: 16777215
    t.text "comment_of_admin", limit: 16777215
    t.string "missing_city"
    t.integer "language_id"
    t.integer "visitor_id"
    t.boolean "anonymous", default: false
    t.text "opted_out_emails"
    t.boolean "message_reminder_active", default: false
    t.boolean "enable_watchlist", default: true
    t.integer "my_bestpractices_count", default: 0
    t.index ["company_name"], name: "index_experts_on_company_name"
    t.index ["email"], name: "index_experts_on_email"
    t.index ["expertise"], name: "index_experts_on_expertise", length: 5
    t.index ["first_name"], name: "index_experts_on_first_name"
    t.index ["last_name"], name: "index_experts_on_last_name"
    t.index ["profession"], name: "index_experts_on_profession"
  end

  create_table "friendly_id_slugs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "goldencobra_article_authors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_article_images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.integer "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "position"
  end

  create_table "goldencobra_article_urls", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_article_widgets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.integer "widget_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_articles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_name"
    t.string "slug"
    t.text "content", limit: 16777215
    t.text "teaser", limit: 16777215
    t.string "ancestry"
    t.boolean "startpage", default: false
    t.boolean "active", default: true
    t.string "subtitle"
    t.text "summary", limit: 16777215
    t.text "context_info", limit: 16777215
    t.string "canonical_url"
    t.boolean "robots_no_index", default: false
    t.string "breadcrumb"
    t.string "template_file"
    t.integer "article_for_index_id"
    t.integer "article_for_index_levels", default: 0
    t.integer "article_for_index_count", default: 0
    t.boolean "enable_social_sharing"
    t.boolean "article_for_index_images", default: false
    t.boolean "cacheable", default: true
    t.string "image_gallery_tags"
    t.string "article_type"
    t.string "external_url_redirect"
    t.string "index_of_articles_tagged_with"
    t.string "sort_order"
    t.boolean "reverse_sort"
    t.integer "sorter_limit"
    t.string "not_tagged_with"
    t.boolean "use_frontend_tags", default: false
    t.string "dynamic_redirection", default: "false"
    t.boolean "redirection_target_in_new_window", default: false
    t.boolean "commentable", default: false
    t.datetime "active_since", default: "2013-12-30 09:47:37"
    t.string "redirect_link_title"
    t.string "display_index_types", default: "all"
    t.integer "creator_id"
    t.string "external_referee_id"
    t.string "external_referee_ip"
    t.datetime "external_updated_at"
    t.string "image_gallery_type", default: "lightbox"
    t.text "url_path", limit: 16777215
    t.integer "global_sorting_id", default: 0
    t.string "display_index_articletypes", default: "all"
    t.string "index_of_articles_descendents_depth", default: "1"
    t.integer "ancestry_depth", default: 0
    t.string "metatag_title_tag"
    t.string "metatag_meta_description"
    t.string "metatag_open_graph_title"
    t.string "metatag_open_graph_description"
    t.string "metatag_open_graph_type", default: "website"
    t.string "metatag_open_graph_url"
    t.string "metatag_open_graph_image"
    t.integer "state", default: 0
    t.boolean "display_index_articles", default: true
    t.boolean "count_page_views", default: true
    t.index ["active"], name: "index_goldencobra_articles_on_active"
    t.index ["ancestry"], name: "index_goldencobra_articles_on_ancestry"
    t.index ["breadcrumb"], name: "index_goldencobra_articles_on_breadcrumb"
    t.index ["slug"], name: "index_goldencobra_articles_on_slug"
    t.index ["title"], name: "index_goldencobra_articles_on_title"
    t.index ["url_name"], name: "index_goldencobra_articles_on_url_name"
    t.index ["url_path"], name: "index_goldencobra_articles_on_url_path", length: 200
  end

  create_table "goldencobra_articletype_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "articletype_group_id"
    t.string "fieldname"
    t.integer "sorter", default: 0
    t.string "class_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_articletype_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.boolean "expert", default: false
    t.boolean "foldable", default: true
    t.boolean "closed", default: true
    t.integer "sorter", default: 0
    t.integer "articletype_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "position", default: "first_block"
  end

  create_table "goldencobra_articletypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "default_template_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_authors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "googleplus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.integer "commentator_id"
    t.string "commentator_type"
    t.text "content", limit: 16777215
    t.boolean "active", default: true
    t.boolean "approved", default: false
    t.boolean "reported", default: false
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_domains", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "hostname"
    t.string "title"
    t.string "client"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_prefix"
    t.boolean "main", default: false
  end

  create_table "goldencobra_dynamic_forms_dynamic_forms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "properties", limit: 16777215
    t.string "dynamicform_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visitor_id"
  end

  create_table "goldencobra_dynamic_forms_dynamicform_fields", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "field_type"
    t.string "name"
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fieldgroup_id"
    t.boolean "hidden"
    t.string "placeholder"
    t.integer "sorter_id", default: 0
    t.string "css_class"
    t.text "settings"
  end

  create_table "goldencobra_dynamic_forms_dynamicform_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "submit_text"
    t.string "redirect_to"
    t.string "email"
    t.string "honeypot"
  end

  create_table "goldencobra_dynamic_forms_field_options", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "value"
    t.integer "dynamicform_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sorter_id", default: 0
  end

  create_table "goldencobra_dynamic_forms_fieldgroups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description", limit: 16777215
    t.integer "dynamicform_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sorter_id", default: 0
  end

  create_table "goldencobra_dynamic_forms_sender_ips", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "form_type_id"
  end

  create_table "goldencobra_helps", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description", limit: 16777215
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_import_metadata", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "database_owner"
    t.datetime "exported_at"
    t.string "database_admin_first_name"
    t.string "database_admin_last_name"
    t.string "database_admin_phone"
    t.string "database_admin_email"
    t.integer "importmetatagable_id"
    t.string "importmetatagable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_imports", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "assignment", limit: 16777215
    t.string "target_model"
    t.boolean "successful"
    t.integer "upload_id"
    t.string "separator", default: ","
    t.text "result", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encoding_type"
    t.text "assignment_groups", limit: 16777215
  end

  create_table "goldencobra_link_checkers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "article_id"
    t.text "target_link"
    t.text "position"
    t.string "response_code"
    t.string "response_time"
    t.text "response_error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goldencobra_locations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "lat"
    t.string "lng"
    t.string "street"
    t.string "city"
    t.string "zip"
    t.string "region"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "locateable_type"
    t.integer "locateable_id"
    t.string "street_number"
    t.boolean "manual_geocoding", default: false
    t.integer "zoom_level", default: 12
  end

  create_table "goldencobra_menues", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "target"
    t.string "css_class"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.integer "sorter", default: 0
    t.text "description", limit: 16777215
    t.string "call_to_action_name"
    t.string "description_title"
    t.integer "image_id"
    t.integer "ancestry_depth", default: 0
    t.boolean "remote", default: false
    t.index ["active"], name: "index_goldencobra_articles_on_active"
    t.index ["ancestry"], name: "index_goldencobra_menues_on_ancestry"
    t.index ["target"], name: "index_goldencobra_articles_on_target"
  end

  create_table "goldencobra_permissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "action"
    t.string "subject_class"
    t.string "subject_id"
    t.integer "role_id"
    t.integer "sorter_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operator_id"
    t.integer "domain_id"
  end

  create_table "goldencobra_redirectors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "source_url"
    t.text "target_url"
    t.integer "redirection_code", default: 301
    t.boolean "active", default: true
    t.boolean "ignore_url_params", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_goldencobra_articles_on_active"
    t.index ["source_url"], name: "index_goldencobra_articles_on_source_url", length: 200
    t.index ["target_url"], name: "index_goldencobra_articles_on_target_url", length: 200
  end

  create_table "goldencobra_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "redirect_after_login", default: "reload"
  end

  create_table "goldencobra_roles_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "operator_id"
    t.integer "role_id"
    t.string "operator_type", default: "User"
  end

  create_table "goldencobra_settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "value"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "data_type", default: "string"
    t.index ["ancestry"], name: "index_goldencobra_articles_on_ancestry"
    t.index ["title", "ancestry"], name: "index_goldencobra_articles_on_title_and_ancestry"
    t.index ["title"], name: "index_goldencobra_articles_on_title"
  end

  create_table "goldencobra_trackings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "request", limit: 16777215
    t.string "session_id"
    t.string "referer"
    t.string "url"
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.string "language"
    t.string "path"
    t.string "page_duration"
    t.string "view_duration"
    t.string "db_duration"
    t.text "url_paremeters", limit: 16777215
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "location"
  end

  create_table "goldencobra_uploads", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "source"
    t.string "rights"
    t.text "description", limit: 16777215
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attachable_id"
    t.string "attachable_type"
    t.string "alt_text"
    t.integer "sorter_number"
    t.string "image_remote_url"
  end

  create_table "goldencobra_vita", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "loggable_id"
    t.string "loggable_type"
    t.integer "user_id"
    t.string "title"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_cd", default: 0
    t.index ["loggable_id"], name: "index_goldencobra_vita_on_loggable_id"
  end

  create_table "goldencobra_widgets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "content", limit: 16777215
    t.string "css_name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "id_name"
    t.integer "sorter"
    t.text "mobile_content", limit: 16777215
    t.string "teaser"
    t.boolean "default"
    t.text "description", limit: 16777215
    t.string "offline_days"
    t.boolean "offline_time_active"
    t.text "alternative_content", limit: 16777215
    t.date "offline_date_start"
    t.date "offline_date_end"
    t.text "offline_time_week_start_end", limit: 16777215
    t.index ["active"], name: "index_goldencobra_articles_on_active"
    t.index ["title", "active"], name: "index_goldencobra_articles_on_title_and_active"
  end

  create_table "instruments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_instruments_on_title"
  end

  create_table "language_skills", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_conversation_opt_outs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string "unsubscriber_type"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "type"
    t.text "body", limit: 16777215
    t.string "subject", default: ""
    t.integer "sender_id"
    t.string "sender_type"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.integer "notified_object_id"
    t.string "notified_object_type"
    t.string "notification_code"
    t.string "attachment"
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "receiver_id"
    t.string "receiver_type"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["notification_id"], name: "index_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "main_actors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_main_actors_on_title"
  end

  create_table "project_areas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_regions_on_title"
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "size_clusters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statistic_page_views", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "views", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "incrementable_id"
    t.string "incrementable_type"
    t.index ["incrementable_type", "incrementable_id"], name: "index_statistic_page_views_on_incrementables"
  end

  create_table "sustainable_development_goals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "color"
    t.integer "sorting_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.index ["title"], name: "index_sustainable_development_goals_on_title"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_topics_on_title"
  end

  create_table "translations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value", limit: 16777215
    t.text "interpolations", limit: 16777215
    t.boolean "is_proc", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "url_links", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "target"
    t.string "title"
    t.integer "best_practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "gender"
    t.string "position"
    t.string "firstname"
    t.string "lastname"
    t.string "function"
    t.string "phone"
    t.string "fax"
    t.string "facebook"
    t.string "twitter"
    t.string "linkedin"
    t.string "xing"
    t.string "googleplus"
    t.boolean "enable_expert_mode", default: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visitors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.boolean "agb", default: false
    t.boolean "newsletter"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts"
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.string "username"
    t.string "loginable_type"
    t.integer "loginable_id"
    t.index ["email"], name: "index_visitors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_visitors_on_reset_password_token", unique: true
  end

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
end
