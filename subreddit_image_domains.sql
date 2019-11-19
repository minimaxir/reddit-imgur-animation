#standardSQL
SELECT
  DATE(TIMESTAMP_TRUNC(TIMESTAMP_SECONDS(created_utc), MONTH)) AS month,
  CASE
    WHEN REGEXP_CONTAINS(domain, 'reddituploads.com|redd.it') THEN "Reddit"
    WHEN REGEXP_CONTAINS(domain, 'imgur.com') THEN "Imgur"
    WHEN REGEXP_CONTAINS(domain, 'gfycat') THEN "Gfycat"
    WHEN REGEXP_CONTAINS(domain, 'giphy') THEN "Giphy"
    WHEN REGEXP_CONTAINS(domain, 'flickr') THEN "Flickr"
    WHEN REGEXP_CONTAINS(domain, 'tumblr') THEN "Tumblr"
    WHEN REGEXP_CONTAINS(domain, 'instagram') THEN "Instagram"
    WHEN REGEXP_CONTAINS(domain, 'facebook') THEN "Facebook"
--   WHEN REGEXP_CONTAINS(domain, 'self.') THEN "(Self Post)"
  ELSE
  "Other"
END
  AS website,
  COUNT(*) AS num_submissions
FROM
  `fh-bigquery.reddit_posts.2019_01`
WHERE
  subreddit = 'pics'
GROUP BY
  month,
  website
ORDER BY
  month,
  num_submissions DESC