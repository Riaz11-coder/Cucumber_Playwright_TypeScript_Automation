import Stripe from 'stripe';

export interface StripeTestContext {
  customer?: Stripe.Customer;
  paymentIntent?: Stripe.PaymentIntent;
  paymentMethod?: Stripe.PaymentMethod;
}

let chargeCard: (amount: number) => Promise<any>;

let stripeInstance: Stripe | null = null;

if (!process.env.STRIPE_SECRET_KEY) {
  console.warn('Stripe tests skipped — STRIPE_SECRET_KEY not set.');

  chargeCard = async (_amount: number): Promise<void> => {
    throw new Error("Stripe is disabled in this environment");
  };
} else {
  stripeInstance = new Stripe(process.env.STRIPE_SECRET_KEY, {
    apiVersion: '2025-03-31.basil',
    typescript: true
  });

  chargeCard = async (amount: number): Promise<any> => {
    return stripeInstance!.charges.create({
      amount,
      currency: 'usd',
      source: 'tok_visa', // Replace with dynamic source/token if needed
    });
  };
}

export { chargeCard, stripeInstance as stripe };
