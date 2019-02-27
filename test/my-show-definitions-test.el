;;; my-show-definitions-test.el --- Tests for my-show-definitions -*- lexical-binding: t -*-

(setq example-imenu-index-alist
      '(("AccountFactory (class)"
         ("*class definition*" . 356)
         ("__call__ (def)" . 572)
         ("_validate_acc_type_obj (def)" . 1175))

        ("Account (class)"
         ("*class definition*" . 1414)
         ("get_descendants_ids (def)" . 1992)
         ("get_name (def)" . 2592))

        ("AccTypeEnum (class)" . 3928)
        ("get_currency_price_change_rebalance_acc (def)" . 4441)))
(setq example-imenu-index-alist-flattened
      '(
        ("AccountFactory (class) - *class definition*" . 356)
        ("AccountFactory (class) - __call__ (def)" . 572)
        ("AccountFactory (class) - _validate_acc_type_obj (def)" . 1175)
        ("Account (class) - *class definition*" . 1414)
        ("Account (class) - get_descendants_ids (def)" . 1992)
        ("Account (class) - get_name (def)" . 2592)
        ("AccTypeEnum (class)" . 3928)
        ("get_currency_price_change_rebalance_acc (def)" . 4441)))

(ert-deftest testing-flatten-imenu-index-alist ()
    (should (equalp (my-show-definitions-flatten-imenu-index-alist
                     example-imenu-index-alist)
                    example-imenu-index-alist-flattened)))
;;; my-show-definitions-test.el ends here
