#!/usr/bin/perl
package Picky::Fonts;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(setfont getfonts);

use strict;
use Carp;

my(%fonts, %faces);

%faces = (
  normal => 710,
  bold   => 711,
  italic => 712,
);


# We can query the terminal for the current font(s) in use. This seems to only
# work in a real XTerm, though:
# echo -e '\e]50;?\a'; xxd
# ^[]50;-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252^G

sub getfonts {
  my %h;
  for my $shortname(keys( %fonts)) {
    $h{$fonts{$shortname}{name}} = $shortname;
  }
  for my $name(sort(keys(%h))) {
    printf("%-7s - %s\n", $h{$name}, $name);
  }
}

sub setfont {
  my($font, $face) = @_;

  if(!defined($font)) {
    croak("Font not specified!");
  }

  my $font_str;
  if(exists($fonts{$font}{font})) {
    $font_str = $fonts{$font}{font};
  }
  else { # The user might have supplied an arbitary font, lets try setting it
    # \e is a GNU thing.
    if( ($ENV{TERM} =~ m/screen/i) and (!exists($ENV{TMUX})) ) {
      printf("\eP\e]$faces{$face};%s\007\a\e\\", $font);
    }
    # $TMUX ought to be set only when queried from inside tmux. Please do not
    # set it outside of tmux.
    # On GNU/Linux it might look like so: /tmp/tmux-1000/default,8295,1
    elsif($ENV{TMUX} =~ m/tmux/) {
      printf("\ePtmux;\e\e]$faces{$face};%s\007\033\\", $font);
    }
    else {
      if($ENV{TERM} =~ m/^xterm/) {
        printf("\e]50;%s\007", $font);
      }
      else {
        printf("\e]710;%s\007", $font);
        printf("\e]711;%s\007", $font);
        printf("\e]712;%s\007", $font);
      }
    }
    return;
  }

  if($ENV{TERM} =~ m/^xterm/) {
    printf("\e]50;%s\007", $font);
    return;
  }

  if(exists($faces{$face})) {
    if( ($ENV{TERM} =~ m/screen/i) and (!exists($ENV{TMUX})) ) {
      printf("\eP\033]$faces{$face};%s\007\a\e\\", $font_str);
    }

    elsif(exists($ENV{TMUX})) {
      printf("\ePtmux;\e\e]$faces{$face};%s\007\033\\", $font_str);
    }
    else {
      printf("\033]$faces{$face};%s\007", $font_str);
    }
  }
  else {
    if( ($ENV{TERM} =~ m/screen/i) and (!exists($ENV{TMUX})) ) {
      printf("\eP\e]710;%s\007", $font_str);
    }
    elsif(exists($ENV{TMUX})) {
      printf("\ePtmux;\e\e]710;%s\007\033\\", $font_str);
    }
    else {
      printf("\e]710;%s\007", $font_str);
      printf("\e]711;%s\007", $font_str);
      printf("\e]712;%s\007", $font_str);
    }
  }
}


%fonts = (
  ter1    => {
    name  => 'Terminus Normal               [ 12px ] (72-72-c-60)',
    font  => '-xos4-terminus-bold-r-normal--12-120-72-72-c-60-koi8-u',
  },
  ter2    => {
    name  => 'Terminus Bold Normal          [ 14px ] (72-72-c-80)',
    font  => '-xos4-terminus-bold-r-normal--14-140-72-72-c-80-koi8-u',
  },
  ter3    => {
    name  => 'Terminus Medium               [ 16px ] (72-72-c-80)',
    font  => '-xos4-terminus-bold-r-normal--16-160-72-72-c-80-koi8-u',
  },
  ter4    => {
    name  => 'Terminus Bold Normal          [ 20px ] (72-72-c-100)',
    font  => '-xos4-terminus-bold-r-normal--20-200-72-72-c-100-koi8-u',
  },
  ter5    => {
    name  => 'Terminus Bold Normal          [ 22px ] (72-72-c-110)',
    font  => '-xos4-terminus-bold-r-normal--22-220-72-72-c-110-koi8-u',
  },
  ter6    => {
    name  => 'Terminus Medium Normal        [ 24px ] (72-72-c-120)',
    font  => '-xos4-terminus-medium-r-normal--24-240-72-72-c-120-koi8-u',
  },
  ter7    => {
    name  => 'Terminus Medium Normal        [ 28px ] (72-72-c-140)',
    font  => '-xos4-terminus-medium-r-normal--28-280-72-72-c-140-koi8-u',
  },
  ter8    => {
    name  => 'Terminus Medium Normal        [ 32px ] (72-72-c-160)',
    font  => '-xos4-terminus-medium-r-normal--32-320-72-72-c-160-koi8-u',
  },
  pro1    => {
    name  => 'Profont Medium Normal         [ 10px ] (72-72-c-50)',
    font  => '-nil-profont-medium-r-normal--10-100-72-72-c-50-iso8859-1',
  },
  pro2    => {
    name  => 'Profont Medium Normal         [ 11px ] (72-72-c-60)',
    font  => '-nil-profont-medium-r-normal--11-110-72-72-c-60-iso8859-1',
  },
  pro3    => {
    name  => 'Profont Medium Normal         [ 12px ] (72-72-c-60)',
    font  => '-nil-profont-medium-r-normal--12-120-72-72-c-60-iso8859-1',
  },
  pro4    => {
    name  => 'Profont Medium Normal         [ 15px ] (72-72-c-70)',
    font  => '-nil-profont-medium-r-normal--15-150-72-72-c-70-iso8859-1',
  },
  pro5    => {
    name  => 'Profont Medium Normal         [ 17px ] (72-72-c-140)',
    font  => '-nil-profont-medium-r-normal--17-170-72-72-c-140-iso8859-1',
  },
  pro6    => {
    name  => 'Profont Medium Normal         [ 22px ] (72-72-c-120)',
    font  => '-nil-profont-medium-r-normal--22-220-72-72-c-120-iso8859-1',
  },
  pro7    => {
    name  => 'Profont Medium Normal         [ 29px ] (72-72-c-160)',
    font  => '-nil-profont-medium-r-normal--29-290-72-72-c-160-iso8859-1',
  },
  dina1   => {
    name  => 'Dina Bold Normal              [ 13px ] (96-96-c-70)',
    font  => '-windows-dina-bold-i-normal--13-80-96-96-c-70-microsoft-cp1252',
  },
  dina2   => {
    name  => 'Dina Bold Normal              [ 15px ] (96-96-c-70)',
    font  => '-windows-dina-bold-i-normal--15-90-96-96-c-70-microsoft-cp1252',
  },
  dina3   => {
    name  => 'Dina Bold Normal              [ 16px ] (96-96-c-80)',
    font  => '-windows-dina-bold-i-normal--16-100-96-96-c-80-microsoft-cp1252',
  },
  dina4   => {
    name  => 'Dina Medium Normal            [ 13px ] (96-96-c-70)',
    font  => '-windows-dina-medium-i-normal--13-80-96-96-c-70-microsoft-cp1252',
  },
  dina5   => {
    name  => 'Dina Medium Normal            [ 15px ] (96-96-c-70)',
    font  => '-windows-dina-medium-i-normal--15-90-96-96-c-70-microsoft-cp1252',
  },
  dina6   => {
    name  => 'Dina Medium Normal            [ 16px ] (96-96-c-70)',
    font  => '-windows-dina-medium-i-normal--16-100-96-96-c-80-microsoft-cp1252',
  },
  proggy1 => {
    name  => 'Proggy Clean Medium           [ 13px ] (96-96-c-70)',
    font  => '-windows-proggyclean-medium-r-normal--13-80-96-96-c-70-iso8859-1',
  },
  proggy2 => {
    name  => 'Proggy Clean Sans CP          [ 13px ] (96-96-c-70)',
    font  => '-windows-proggycleancp-medium-r-normal-sans-13-80-96-96-c-70-iso8859-1',
  },
  proggy3 => {
    name  => 'Proggy Clean Striked Zero     [ 13px ] (96-96-c-70)',
    font  => '-windows-proggycleansz-medium-r-normal--13-80-96-96-c-70-iso8859-1',
  },
  proggy4 => {
    name  => 'Proggy Clean BP               [ 13px ] (96-96-c-70)',
    font  => '-windows-proggycleanszbp-medium-r-normal--13-80-96-96-c-70-iso8859-1'
  },
  proggy5 => {
    name  => 'Proggy Opti Standard          [ 11px ] (96-96-c-70)',
    font  => '-windows-proggyopti-medium-r-normal--11-80-96-96-c-70-iso8859-1',
  },
  proggy6 => {
    name  => 'Proggy Optis                  [ 10px ] (96-96-c-60)',
    font  => '-windows-proggyoptis-medium-r-normal--10-80-96-96-c-60-iso8859-1',
  },
  proggy7 => {
    name  => 'Proggy Small                  [ 10px ] (96-96-c-70)',
    font  => '-windows-proggysmall-medium-r-normal--10-80-96-96-c-70-iso8859-1',
  },
  proggy8 => {
    name  => 'Proggy Square                 [ 11px ] (96-96-c-70)',
    font  => '-windows-proggysquare-medium-r-normal--11-80-96-96-c-70-iso8859-1',
  },
  proggy9 => {
    name  => 'Proggy Square Striked Zero    [ 11px ] (96-96-c-70)',
    font  =>
    '-windows-proggysquaresz-medium-r-normal--11-80-96-96-c-70-iso8859-1',
  },
  speedy1 => {
    name  => 'Speedy Medium Normal          [ 11px ] (96-96-c-70)',
    font  => '-windows-speedy-medium-r-normal--11-80-96-96-c-70-iso8859-1',
  },
  speedy2 => {
    name  => 'Speedy Medium Normal          [ 12px ] (96-96-c-70)',
    font  => '-windows-speedy-medium-r-normal--12-90-96-96-c-70-iso8859-1',
  },
  clean1  => {
    name  => 'Clean Bold Normal             [ 10px ] (75-75-c-60)',
    font  => '-schumacher-clean-bold-r-normal--10-100-75-75-c-60-iso646.1991-irv',
  },
  clean2  => {
    name  => 'Clean Bold Normal             [ 10px ] (75-75-c-80)',
    font  => '-schumacher-clean-bold-r-normal--10-100-75-75-c-80-iso646.1991-irv',
  },
  clean3  => {
    name  => 'Clean Bold Normal             [ 12px ] (75-75-c-60)',
    font  => '-schumacher-clean-bold-r-normal--12-120-75-75-c-60-iso646.1991-irv',
  },
  clean4  => {
    name  => 'Clean Bold Normal             [ 12px ] (75-75-c-80)',
    font  => '-schumacher-clean-bold-r-normal--12-120-75-75-c-80-iso646.1991-irv',
  },
  clean5  => {
    name  => 'Clean Bold Normal             [ 13px ] (75-75-c-80)',
    font  => '-schumacher-clean-bold-r-normal--13-130-75-75-c-80-iso646.1991-irv',
  },
  clean6  => {
    name  => 'Clean Bold Normal             [ 14px ] (75-75-c-80)',
    font  => '-schumacher-clean-bold-r-normal--14-140-75-75-c-80-iso646.1991-irv',
  },
  clean7  => {
    name  => 'Clean Bold Normal             [ 15px ] (75-75-c-90)',
    font  => '-schumacher-clean-bold-r-normal--15-150-75-75-c-90-iso646.1991-irv',
  },
  clean8  => {
    name  => 'Clean Medium Normal           [ 8px  ] (75-75-c-80)',
    font  => '-schumacher-clean-medium-i-normal--8-80-75-75-c-80-iso646.1991-irv',
  },
  clean9  => {
    name  => 'Clean Medium Normal           [ 10px ] (75-75-c-50)',
    font  => '-schumacher-clean-medium-r-normal--10-100-75-75-c-50-iso646.1991-irv',
  },
  clean10 => {
    name  => 'Clean Medium Normal           [ 10px ] (75-75-c-60)',
    font  => '-schumacher-clean-medium-r-normal--10-100-75-75-c-60-iso646.1991-irv',
  },
  clean11 => {
    name  => 'Clean Medium Normal           [ 10px ] (75-75-c-70)',
    font  => '-schumacher-clean-medium-r-normal--10-100-75-75-c-70-iso646.1991-irv',
  },
  clean12 => {
    name  => 'Clean Medium Normal           [ 12px ] (75-75-c-60)',
    font  => '-schumacher-clean-medium-r-normal--12-120-75-75-c-60-koi8-r',
  },
  '10x20' => {
    name  => '10x20                         [CONSOLE]',
    font  => '10x20',
  },
  '12x24' => {
    name  => '12x24                         [CONSOLE]',
    font  => '12x24',
  },
  '5x7'   => {
    name  => '5x7                           [CONSOLE]',
    font  => '5x7',
  },
  '5x8'   => {
    name  => '5x8                           [CONSOLE]',
    font  => '5x8',
  },
  '6x10'  => {
    name  => '6x10                          [CONSOLE]',
    font  => '6x10',
  },
  '6x12'  => {
    name  => '6x12                          [CONSOLE]',
    font  => '6x12',
  },
  '6x13'  => {
    name  => '6x13                          [CONSOLE]',
    font  => '6x13',
  },
  '6x13b' => {
    name  => '6x13 Bold                     [CONSOLE]',
    font  => '6x13bold',
  },
  'luco1' => {
    name  => 'Lucida ConsoleP               [10px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=10:antialias=0',
  },
  'luco2' => {
    name  => 'Lucida ConsoleP               [11px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=11:antialias=0',
  },
  'luco3' => {
    name  => 'Lucida ConsoleP               [12px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=12:antialias=0',
  },
  'luco4' => {
    name  => 'Lucida ConsoleP               [13px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=13:antialias=0',
  },
  'luco5' => {
    name  => 'Lucida ConsoleP               [14px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=14:antialias=0',
  },
  'luco6' => {
    name  => 'Lucida ConsoleP               [15px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=15:antialias=0',
  },
  'luco7' => {
    name  => 'Lucida ConsoleP               [16px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=16:antialias=0',
  },
  'luco8' => {
    name  => 'Lucida ConsoleP               [17px] [XFT]',
    font  => 'xft:Lucida ConsoleP:pixelsize=17:antialias=0',
  },
  fixed1  => {
    name  => 'Fixed Medium Normal           [ 10px ] (75-75-c-60)',
    font  => '-misc-fixed-medium-r-normal--10-100-75-75-c-60-koi8-r',
  },
  fixed2  => {
    name  => 'Fixed Medium Normal           [ 13px ] (75-75-c-70)',
    font  => '-misc-fixed-medium-r-normal--13-120-75-75-c-70-koi8-r',
  },
  fixed3  => {
    name  => 'Fixed Medium Normal           [ 13px ] (75-75-c-80)',
    font  => '-misc-fixed-medium-r-normal--13-120-75-75-c-80-koi8-r',
  },
  fixed4  => {
    name  => 'Fixed Medium Normal           [ 14px ] (75-75-c-70)',
    font  => '-misc-fixed-medium-r-normal--14-130-75-75-c-70-koi8-r',
  },
  fixed5  => {
    name  => 'Fixed Medium Normal           [ 15px ] (75-75-c-90)',
    font  => '-misc-fixed-medium-r-normal--15-140-75-75-c-90-koi8-r',
  },
  fixed6  => {
    name  => 'Fixed Medium Normal           [ 18px ] (100-100-c-90)',
    font  => '-misc-fixed-medium-r-normal--18-120-100-100-c-90-koi8-r',
  },
  fixed7  => {
    name  => 'Fixed Medium Normal           [ 22px ] (75-75-c-100)',
    font  => '-misc-fixed-medium-r-normal--20-200-75-75-c-100-koi8-r',
  },
  fixed8  => {
    name  => 'Fixed Medium Normal           [ 6px  ] (75-75-c-40)',
    font  => '-misc-fixed-medium-r-normal--6-60-75-75-c-40-koi8-r',
  },
  fixed9  => {
    name  => 'Fixed Medium Normal           [ 7px  ] (75-75-c-50)',
    font  => '-misc-fixed-medium-r-normal--7-70-75-75-c-50-koi8-r',
  },
  fixed10 => {
    name  => 'Fixed Medium Normal           [ 8px  ] (75-75-c-50)',
    font  => '-misc-fixed-medium-r-normal--8-80-75-75-c-50-koi8-r',
  },
  fixed11 => {
    name  => 'Fixed Medium Normal           [ 9px  ] (75-75-c-60)',
    font  => '-misc-fixed-medium-r-normal--9-90-75-75-c-60-koi8-r',
  },
  monte1  => {
    name  => 'Monte Carlo Medium            [ 11px ] (72-72-c-60)',
    font  => '-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252',
  },
  monte2  => {
    name  => 'Monte Carlo Bold              [ 11px ] (72-72-c-60)',
    font  => '-windows-montecarlo-bold-r-normal--11-110-72-72-c-60-microsoft-cp1252',
  },
);

1;
