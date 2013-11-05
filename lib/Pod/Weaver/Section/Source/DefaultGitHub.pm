package Pod::Weaver::Section::Source::DefaultGitHub;

use 5.010001;
use Moose;
#use Text::Wrap ();
with 'Pod::Weaver::Role::Section';

#use Log::Any '$log';

use Moose::Autobox;

our $VERSION = '0.04'; # VERSION

sub weave_section {
  my ($self, $document, $input) = @_;

  my $repo_url = $input->{distmeta}{resources}{repository};
  if (ref($repo_url) eq 'HASH') { $repo_url = $repo_url->{web} }
  if (!$repo_url) {
      my $file = ".git/config";
      die "Can't find git config file $file" unless -f $file;
      my $ct = do {
          local $/;
          open my($fh), "<", $file or die "Can't open $file: $!";
          ~~<$fh>;
      };
      $ct =~ m!github\.com:([^/]+)/(.+)\.git!
          or die "Can't parse github address in $file";
      $repo_url = "https://github.com/$1/$2";
  }
  my $text = "Source repository is at L<$repo_url>.";

  #$text = Text::Wrap::wrap(q{}, q{}, $text);

  $document->children->push(
    Pod::Elemental::Element::Nested->new({
      command  => 'head1',
      content  => 'SOURCE',
      children => [
        Pod::Elemental::Element::Pod5::Ordinary->new({ content => $text }),
      ],
    }),
  );
}

no Moose;
1;
# ABSTRACT: Add a SOURCE section (repository defaults to GitHub)

__END__

=pod

=encoding utf-8

=head1 NAME

Pod::Weaver::Section::Source::DefaultGitHub - Add a SOURCE section (repository defaults to GitHub)

=head1 VERSION

version 0.04

=head1 SYNOPSIS

In your C<weaver.ini>:

 [Source::DefaultGitHub]

If C<repository> is not specified in dist.ini, will search for github user/repo
name from git config file (C<.git/config>).

To specify a source repository other than C<https://github.com/USER/REPO>, in
dist.ini:

 [MetaResources]
 repository=http://example.com/

=head1 DESCRIPTION

This section plugin adds a SOURCE section, using C<repository> metadata or (if
not specified) GitHub.

=for Pod::Coverage weave_section

=head1 SEE ALSO

L<Pod::Weaver::Section::SourceGitHub>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Pod-Weaver-Section-Source-DefaultGitHub>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Pod-Weaver-Section-Source-DefaultGitHub>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://rt.cpan.org/Public/Dist/Display.html?Name=Pod-Weaver-Section-Source
-DefaultGitHub

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
