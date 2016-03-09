require 'tree'
require 'securerandom'

module Marvin

  # Subclass and namespace +Tree::TreeNode+.
  class Node < Tree::TreeNode

    def initialize(content)
      super(SecureRandom.hex, content)
    end
  end
end
