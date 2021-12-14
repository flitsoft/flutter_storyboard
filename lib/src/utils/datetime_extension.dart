extension IsSameOrAfter on DateTime {
  isSameOrAfter(DateTime dateTime) {
    return isAtSameMomentAs(dateTime) || isAfter(dateTime);
  }
}
