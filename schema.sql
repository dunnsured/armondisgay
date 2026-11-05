-- aux. example schema (revised)

CREATE TABLE albums (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  artist_id INTEGER NOT NULL REFERENCES artists(id),
  release_year INTEGER,
  cover_url TEXT,
  external_spotify_id TEXT
);

CREATE TABLE answer_trait_points (
  attempt_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  trait_id INTEGER NOT NULL REFERENCES traits(id),
  points INTEGER NOT NULL,
  PRIMARY KEY (attempt_id, question_id, trait_id),
  FOREIGN KEY (attempt_id, question_id) REFERENCES quiz_answers(attempt_id, question_id)
);

CREATE TABLE artists (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  external_spotify_id TEXT,
  image_url TEXT,
  is_niche INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE bookmarks (
  user_id INTEGER NOT NULL REFERENCES users(id),
  review_id INTEGER NOT NULL REFERENCES reviews(id),
  created_at TEXT NOT NULL,
  PRIMARY KEY (user_id, review_id)
);

CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  parent_id INTEGER REFERENCES categories(id),
  UNIQUE(name, parent_id)
);

CREATE TABLE category_assets (
  id INTEGER PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES categories(id),
  title TEXT NOT NULL,
  media_type TEXT NOT NULL CHECK(media_type IN ('image','video','album_cover','audio')),
  url TEXT,
  source_label TEXT,
  note TEXT
);

CREATE TABLE comments (
  id INTEGER PRIMARY KEY,
  review_id INTEGER NOT NULL REFERENCES reviews(id),
  user_id INTEGER NOT NULL REFERENCES users(id),
  body TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE compatibility (
  user_a_id INTEGER NOT NULL REFERENCES users(id),
  user_b_id INTEGER NOT NULL REFERENCES users(id),
  score REAL NOT NULL CHECK(score BETWEEN 0 AND 100),
  computed_at TEXT NOT NULL,
  PRIMARY KEY (user_a_id, user_b_id),
  CHECK (user_a_id < user_b_id)
);

CREATE TABLE follows (
  follower_id INTEGER NOT NULL REFERENCES users(id),
  followee_id INTEGER NOT NULL REFERENCES users(id),
  is_close_friend INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  PRIMARY KEY (follower_id, followee_id),
  CHECK (follower_id != followee_id)
);

CREATE TABLE house_aliases (
  id INTEGER PRIMARY KEY,
  house_id INTEGER NOT NULL REFERENCES houses(id),
  alias TEXT NOT NULL UNIQUE
);

CREATE TABLE house_trait_weights (
  house_id INTEGER NOT NULL REFERENCES houses(id),
  trait_id INTEGER NOT NULL REFERENCES traits(id),
  weight REAL NOT NULL CHECK(weight >= 0),
  PRIMARY KEY (house_id, trait_id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  color TEXT NOT NULL,
  keywords TEXT NOT NULL,
  listening_habit TEXT
);

CREATE TABLE likes (
  user_id INTEGER NOT NULL REFERENCES users(id),
  review_id INTEGER NOT NULL REFERENCES reviews(id),
  created_at TEXT NOT NULL,
  PRIMARY KEY (user_id, review_id)
);

CREATE TABLE list_items (
  list_id INTEGER NOT NULL REFERENCES lists(id),
  item_type TEXT NOT NULL CHECK(item_type IN ('song','album','artist')),
  item_id INTEGER NOT NULL,
  position INTEGER NOT NULL,
  PRIMARY KEY (list_id, position)
);

CREATE TABLE listen_status (
  user_id INTEGER NOT NULL REFERENCES users(id),
  item_type TEXT NOT NULL CHECK(item_type IN ('song','album')),
  item_id INTEGER NOT NULL,
  status TEXT NOT NULL CHECK(status IN ('to_listen','listened')),
  updated_at TEXT NOT NULL,
  PRIMARY KEY (user_id, item_type, item_id)
);

CREATE TABLE listening_events (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  song_id INTEGER NOT NULL REFERENCES songs(id),
  played_at TEXT NOT NULL
);

CREATE TABLE lists (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  name TEXT NOT NULL,
  description TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE notifications (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  type TEXT NOT NULL,
  actor_id INTEGER REFERENCES users(id),
  ref_type TEXT,
  ref_id INTEGER,
  read_at TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE onboarding_picks (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  prompt TEXT NOT NULL CHECK(prompt IN ('top_artist','life_album','niche_artist','takeoff_song')),
  item_type TEXT NOT NULL CHECK(item_type IN ('artist','album','song')),
  item_id INTEGER NOT NULL
);

CREATE TABLE quiz_answers (
  attempt_id INTEGER NOT NULL REFERENCES quiz_attempts(id),
  question_id INTEGER NOT NULL REFERENCES quiz_questions(id),
  item_type TEXT NOT NULL CHECK(item_type IN ('song','album')),
  item_id INTEGER NOT NULL,
  reason_id INTEGER REFERENCES reason_options(id),
  PRIMARY KEY (attempt_id, question_id)
);

CREATE TABLE quiz_attempts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  path_chosen TEXT,
  path_coin_flip INTEGER NOT NULL DEFAULT 0,
  house_id INTEGER REFERENCES houses(id),
  house_coin_flip INTEGER NOT NULL DEFAULT 0,
  completed_at TEXT
);

CREATE TABLE quiz_questions (
  id INTEGER PRIMARY KEY,
  prompt TEXT NOT NULL,
  path TEXT NOT NULL CHECK(path IN ('universal','nostalgia','adventure','loyalty','curiosity')),
  order_no INTEGER NOT NULL,
  answer_type TEXT NOT NULL CHECK(answer_type IN ('song','album'))
);

CREATE TABLE reason_options (
  id INTEGER PRIMARY KEY,
  label TEXT NOT NULL UNIQUE
);

CREATE TABLE reason_trait_points (
  reason_id INTEGER NOT NULL REFERENCES reason_options(id),
  trait_id INTEGER NOT NULL REFERENCES traits(id),
  points INTEGER NOT NULL,
  is_placeholder INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (reason_id, trait_id)
);

CREATE TABLE reviews (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  item_type TEXT NOT NULL CHECK(item_type IN ('song','album')),
  item_id INTEGER NOT NULL,
  stars REAL NOT NULL CHECK(stars >= 0.5 AND stars <= 5.0 AND (stars*2)=ROUND(stars*2)),
  review_text TEXT,
  visibility TEXT NOT NULL CHECK(visibility IN ('public','friends','close_friends')) DEFAULT 'public',
  created_at TEXT NOT NULL
);

CREATE TABLE songs (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  artist_id INTEGER NOT NULL REFERENCES artists(id),
  album_id INTEGER REFERENCES albums(id),
  release_year INTEGER,
  tempo_bpm REAL,
  valence REAL,
  external_spotify_id TEXT
);

CREATE TABLE stories (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  song_id INTEGER NOT NULL REFERENCES songs(id),
  caption TEXT,
  created_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);

CREATE TABLE traits (
  id INTEGER PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL
);

CREATE TABLE user_category_tags (
  user_id INTEGER NOT NULL REFERENCES users(id),
  category_id INTEGER NOT NULL REFERENCES categories(id),
  PRIMARY KEY (user_id, category_id)
);

CREATE TABLE user_top_albums (
  user_id INTEGER NOT NULL REFERENCES users(id),
  album_id INTEGER NOT NULL REFERENCES albums(id),
  rank INTEGER NOT NULL CHECK(rank BETWEEN 1 AND 3),
  PRIMARY KEY (user_id, rank)
);

CREATE TABLE user_top_artists (
  user_id INTEGER NOT NULL REFERENCES users(id),
  artist_id INTEGER NOT NULL REFERENCES artists(id),
  rank INTEGER NOT NULL CHECK(rank BETWEEN 1 AND 10),
  scrobble_count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, rank)
);

CREATE TABLE user_top_songs (
  user_id INTEGER NOT NULL REFERENCES users(id),
  song_id INTEGER NOT NULL REFERENCES songs(id),
  rank INTEGER NOT NULL CHECK(rank BETWEEN 1 AND 5),
  PRIMARY KEY (user_id, rank)
);

CREATE TABLE user_trait_scores (
  user_id INTEGER NOT NULL REFERENCES users(id),
  trait_id INTEGER NOT NULL REFERENCES traits(id),
  score INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, trait_id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  handle TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  pinned_quote TEXT,
  pinned_quote_artist TEXT,
  is_verified INTEGER NOT NULL DEFAULT 0,
  profile_visibility TEXT NOT NULL CHECK(profile_visibility IN ('public','close_friends')) DEFAULT 'public',
  house_id INTEGER REFERENCES houses(id),
  is_pro INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
