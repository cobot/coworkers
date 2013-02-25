## see discussion here: https://github.com/couchrest/couchrest/issues/92
module CouchRest
  module RestAPI
    private
    # Parse the response provided.
    def parse_response(result, opts = {})
      (opts.delete(:raw) || opts.delete(:head)) ? result : JSON.parse(result, opts.update({:max_nesting => false, :create_additions => true}))
    end
  end
end