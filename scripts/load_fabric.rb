#!/usr/bin/ruby

# Load environment variables.
require 'dotenv'
Dotenv.load

`'#{ENV['PODS_ROOT']}/Fabric/run' #{ENV['FABRIC_API_KEY']} #{ENV['FABRIC_BUILD_SECRET']}`
