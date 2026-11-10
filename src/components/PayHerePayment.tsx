"use client";

import { useState } from "react";
import { API_BASE_URL } from "@/lib/api/client";

type PayHereFields = Record<string, string>;

type PayHereCheckout = { actionUrl: string; fields: PayHereFields };

export function PayHerePayment({ reference }: { reference: string }) {
  const [message, setMessage] = useState("");
  const [processing, setProcessing] = useState(false);

  async function startPayHere() {
    if (!reference) {
      setMessage("No booking reference found. Please start a new booking.");
      return;
    }
    setProcessing(true);
    setMessage("Preparing PayHere checkout...");
    let checkout: PayHereCheckout;
    try {
      const res = await fetch(`${API_BASE_URL}/payments/payhere/create`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ reference }),
      });
      const json = await res.json();
      if (!res.ok || !json.success) throw new Error(json.error?.message ?? "Payment could not be started.");
      checkout = json.data as PayHereCheckout;
    } catch (error) {
      setProcessing(false);
      setMessage(error instanceof Error ? error.message : "Payment could not be started.");
      return;
    }

    // Auto-submit a hidden form to PayHere hosted checkout (sandbox or live).
    const form = document.createElement("form");
    form.method = "POST";
    form.action = checkout.actionUrl;
    form.style.display = "none";
    for (const [key, value] of Object.entries(checkout.fields)) {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = key;
      input.value = value;
      form.appendChild(input);
    }
    document.body.appendChild(form);
    setMessage("Opening PayHere secure checkout...");
    form.submit();
  }

  async function bankTransfer() {
    const bankReference = prompt("Enter bank transfer reference");
    if (!bankReference) return;
    const res = await fetch(`${API_BASE_URL}/payments/bank-transfer`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ reference, bankReference }),
    });
    const json = await res.json();
    setMessage(json.success ? "Bank transfer reference submitted for admin review." : json.error?.message);
  }

  return (
    <div className="mx-auto max-w-3xl bg-white p-8">
      <p className="font-label-lg text-label-lg uppercase tracking-widest text-tertiary">Payment</p>
      <h1 className="mt-3 font-headline-lg text-headline-lg-mobile text-primary md:text-headline-lg">Complete booking {reference}</h1>
      <p className="mt-4 text-on-surface-variant">Press “Pay with PayHere” to open the secure PayHere checkout. Your booking is only confirmed after PayHere confirms the payment to our server.</p>
      <div className="mt-8 flex flex-col gap-3 sm:flex-row">
        <button onClick={startPayHere} disabled={processing} className="bg-primary px-6 py-4 font-label-lg text-label-lg uppercase tracking-widest text-white disabled:opacity-60">
          {processing ? "Opening checkout…" : "Pay with PayHere"}
        </button>
        <button onClick={bankTransfer} className="border border-primary px-6 py-4 font-label-lg text-label-lg uppercase tracking-widest text-primary">Bank transfer</button>
      </div>
      {message && <p className="mt-6" role="status">{message}</p>}
    </div>
  );
}
