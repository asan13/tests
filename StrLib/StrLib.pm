package StrLib;
use common::sense;

require Exporter;
our @ISA = 'Exporter';
our @EXPORT_OK = qw/x_strstr/;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load(StrLib => $VERSION);

1;
