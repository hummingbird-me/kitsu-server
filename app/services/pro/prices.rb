module Pro
  PRICES = {
    gift: {
      '1month' => BigDecimal('2.99'),
      '1year'=> BigDecimal('29.99'),
      'forever' => BigDecimal('99.99')
    },
    subscription: {
      'monthly' => BigDecimal('2.99'),
      'yearly' => BigDecimal('29.99')
    }
  }
end
