# for now cause i dont have the sppons to fix (2025-02-01)
# this abuses the fact that overlays are secretly order dependent by
# implementation. Combine this with clever file name punning and you get...
# C R I M E S
# R
# I
# M
# E
# S
# VERY BAD. DO NOT DO THIS.
# Obviously.
# excepting of course when you need to.
#
# rules for thee, not for mee, etc etc #womenInMaleDominatedFields
final: prev: {
  nix = prev.lixPackageSets.stable.lix;
}
