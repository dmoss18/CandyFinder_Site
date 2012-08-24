# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 2

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "/home/ty/CandyFinder/"

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen 8050

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "/home/ty/CandyFinder/log/unicorn.stderror.log"
stdout_path "/home/ty/CandyFinder/log/unicorn.stdout.log"
