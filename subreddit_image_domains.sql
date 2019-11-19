#standardSQL
WITH top_image_subreddits AS (
  SELECT
    subreddit
  FROM
    `fh-bigquery.reddit_posts.*`
  WHERE
    _TABLE_SUFFIX BETWEEN '2019_06' AND '2019_08'
  GROUP BY
    subreddit
  HAVING
    COUNT(*) >= 2000
    AND SUM(
    IF
      (REGEXP_CONTAINS(domain, 'reddituploads|redd.it|imgur|gfycat|giphy|flickr|instagram'),
        1,
        0))/COUNT(*) > 0.8
  ORDER BY
    APPROX_COUNT_DISTINCT(author) DESC
  LIMIT
    50 )
    
SELECT
  DATE(TIMESTAMP_TRUNC(TIMESTAMP_SECONDS(created_utc), MONTH)) AS month,
  subreddit,
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
  `fh-bigquery.reddit_posts.*`
WHERE
  _TABLE_SUFFIX BETWEEN '2019_06' AND '2019_08'
  AND subreddit IN (SELECT subreddit FROM top_image_subreddits)
GROUP BY
  month,
  subreddit,
  website
ORDER BY
  month,
  subreddit,
  num_submissions DESC
