# frozen_string_literal: true

require 'forwardable'

require_relative './build_updated_body/accepted_mtp'
require_relative './build_updated_body/proposed_mtp'

# Class to build an "updated body" string for an Article, containing
#   1. the content previously preceding the content selected for proposal;
#   2. an accepted-contribution marker tag pair, with a specified identifier;
#   3. the proposed (now accepted) replacement content; and
#   4. the content previously following the content selected for proposal.
class BuildUpdatedBody
  extend Forwardable

  def initialize(find_article:, identifier:, proposal:)
    @find_article = find_article
    @identifier = identifier
    @proposal = proposal
    self
  end

  def call
    all_parts.join
  end

  private

  attr_reader :find_article, :identifier, :proposal

  def_delegator :proposal, :identifier, :proposal_identifier
  def_delegator :proposal, :proposed_content

  def accepted_mtp
    AcceptedMTP.new identifier
  end

  def all_parts
    [lead, accepted_mtp, proposed_content, tail]
  end

  def article
    find_article.call proposal.article_id
  end

  def article_body
    @article_body ||= article&.first&.body.to_s
  end

  def lead
    begin_marker = paired_marker :begin
    article_body.split(begin_marker).first
  end

  def paired_marker(which_end)
    ProposedMTP.new proposal_identifier, which_end
  end

  def tail
    end_marker = paired_marker :end
    article_body.split(end_marker).last
  end
end
